Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab0IWXUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:20:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54705 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753413Ab0IWXUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:20:54 -0400
Date: Fri, 24 Sep 2010 00:43:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pata_it821x driver reports many FLUSH CACHE command failures
Message-ID: <20100924004343.0abebfad@lxorguk.ukuu.org.uk>
In-Reply-To: <20100923172724.0da07fb1@katamari>
References: <20100923172724.0da07fb1@katamari>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010 17:27:24 -0400
Chuck Ebbert <cebbert@redhat.com> wrote:

> It looks like pata_it821x has never supported FLUSH_CACHE, but now

That depends on the firmware you have I believe

The ident it provides also doesn't advertise flush cache so something
appears to be issuing a cache flush despite the drive reporting that it
is not supported.

> we're seeing repeated failures. They happen over and over again and
> prevent installation. I stuck a dump_stack() in the failure path and
> got this:

Yes you'll crash some firmware versions if this occurs.

See:

static unsigned int it821x_read_id(struct ata_device *adev,
                                        struct ata_taskfile *tf, u16 *id)


If this has stopped working then you probably want to get Jeff to trace
back into the ATA and SCSI midlayer to see why it is issuing flushes for
a device which is reporting that cache flush is not supported - because
that is seriously broken.


