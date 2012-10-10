Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab2JJBzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 21:55:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48833 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755250Ab2JJBzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 21:55:40 -0400
Date: Wed, 10 Oct 2012 10:55:31 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware: Don't attempt to allocate zero bytes with
 vmalloc()
Message-ID: <20121010015529.GC17288@opensource.wolfsonmicro.com>
References: <1349456731-19977-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACVXFVOuQosgF+w6k1RH5D360J4pTM-N=quiSCc=GmWt0102rA@mail.gmail.com>
 <20121009041947.GB8237@opensource.wolfsonmicro.com>
 <CACVXFVOT+_nWxZOV0hckVrJwafgb_qr35eKaYg9j=toEJ2DNMQ@mail.gmail.com>
 <20121009071343.GW8237@opensource.wolfsonmicro.com>
 <CACVXFVN1sL1FwUx9t1kQZHW=J-v3_9gDj+jOH2wLgP_a+ywX7g@mail.gmail.com>
 <20121009074138.GB8237@opensource.wolfsonmicro.com>
 <CACVXFVONtkA5tUq3zcvrn6+RmC0_VLgeK5aR7g8yV2dJbgCysA@mail.gmail.com>
 <20121009123629.GB11061@opensource.wolfsonmicro.com>
 <CACVXFVNZPxG3pNnQfSEqvPvLV3LoutFCX_0eZpwjAWEwd8RByA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNZPxG3pNnQfSEqvPvLV3LoutFCX_0eZpwjAWEwd8RByA@mail.gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 10:55:17PM +0800, Ming Lei wrote:
> On Tue, Oct 9, 2012 at 8:36 PM, Mark Brown
> > On Tue, Oct 09, 2012 at 08:02:18PM +0800, Ming Lei wrote:

> > It doesn't really help as the ABI is such that you can only have one

> Could you let me know where the ABI is?

It's defined by firmware_class?

> > request_firmware() in play at once (unless this changed since I last
> > looked at it).

> I guess you mean that only one firmware device can be added
> as child of the device which is requesting firmware.

> The commit below(already merged into linus tree) should fix
> the problem:

>     99c2aa72306079976369aad7fc62cc71931d692a(firmware loader:
>     fix creation failure of fw loader device)

That's not been well advertised (and is extremely recent too)...

> Could you test it to see if more than one request_firmware_nowait()
> can be called concurrently for the same device?

Not for some time.
