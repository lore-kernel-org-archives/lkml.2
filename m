Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab2EXPxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:53:42 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58973 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab2EXPxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:53:40 -0400
Date: Thu, 24 May 2012 16:56:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, hdegoede@redhat.com
Subject: Re: pwc driver bugs
Message-ID: <20120524165638.0ade5a6f@pyramind.ukuu.org.uk>
In-Reply-To: <4FBE4DD5.50906@xs4all.nl>
References: <4FBE4DD5.50906@xs4all.nl>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2012 17:03:49 +0200
Udo van den Heuvel <udovdh@xs4all.nl> wrote:

> Hello,
> 
> I discovered some issues in the pwc driver for certain USB webcams.
> I opened some bugs[1].
> I do think both issues might be related and the crash issue is quite
> serious.
> 
> Please have a look, I can assist by testing any patches with fixes. (for
> ~3.3.7)

commit ceede9fa8939e40ad0ddb4ad1355f45c6f1d3478

looks rather relevant here.

commit ceede9fa8939e40ad0ddb4ad1355f45c6f1d3478
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Wed May 9 04:43:12 2012 -0300

    [media] pwc: Fix locking
    
    My last locking rework for pwc mistakenly assumed that videbuf2 does
    its own locking, but it does not! This patch fixes the missing
    locking by moving over the the video_device lock, and introducing a
    separate lock for the videobuf2_queue.
    
    Signed-off-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
