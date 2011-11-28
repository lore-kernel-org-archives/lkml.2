Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab1K1Tmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:42:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623Ab1K1Tmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:42:43 -0500
Date: Mon, 28 Nov 2011 14:40:26 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: Dmitry Nezhevenko <dion@inhex.net>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        kernel-team@fedpraproject.org,
        Thomas Poussevin <thomas.poussevin@parrot.com>
Subject: Re: Linux 3.1.3
Message-ID: <20111128144026.2dc55946@katamari>
In-Reply-To: <20111128173708.GA3785@laptop.local>
References: <20111127190735.GA11899@kroah.com>
	<20111128173708.GA3785@laptop.local>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Nov 2011 19:37:09 +0200
Dmitry Nezhevenko <dion@inhex.net> wrote:

> On Mon, Nov 28, 2011 at 04:07:35AM +0900, Greg KH wrote:
> > I'm announcing the release of the 3.1.3 kernel.
> > 
> > All users of the 3.1 kernel series must upgrade.
> > 
> 
> I don't know where to report this, since bugzilla is still down. This
> upgrade breaks UVC webcam that I've:
> 
> Bus 002 Device 002: ID 04f2:b029 Chicony Electronics Co., Ltd 1.3M UVC
> Webcam
> 
> I'm getting followed while trying to capture from it:
> 
> 	[  187.555352] uvcvideo: Failed to submit URB 0 (-28).
> 

Almost certainly caused by:

Subject: USB: EHCI: fix HUB TT scheduling issue with iso transfer
From: Thomas Poussevin <thomas.poussevin@parrot.com>
commit 811c926c538f7e8d3c08b630dd5844efd7e000f6 upstream.

This was also reported to cause problems in 3.2-rc but I never saw any reply
to that report:

http://lkml.org/lkml/2011/11/26/63

