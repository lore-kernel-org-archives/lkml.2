Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071Ab2JSPiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:38:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59445 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758293Ab2JSPiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:38:02 -0400
Message-ID: <508173D6.6040209@zytor.com>
Date: Fri, 19 Oct 2012 08:37:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Randy Wright <rwright@hp.com>, linux-kernel@vger.kernel.org,
        Thavatchai Makphaibulchoke <tmac@hp.com>
Subject: Re: [PATCH RFC] function probe_roms accessing improper addresses
References: <jQZho-4fF-13@gated-at.bofh.it> <jSWfn-7B6-3@gated-at.bofh.it> <50816FC9.5080108@hp.com> <20121019153015.GD28212@srcf.ucam.org>
In-Reply-To: <20121019153015.GD28212@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 08:30 AM, Matthew Garrett wrote:
> I don't think DMI checking is going to work, since (a) as you say,
> there's a risk that the ID will inadvertantly change over the lifecycle
> of the machine, and (b) there may be other machines. So if it's not
> possible to handle this by catching the MCE, I think we have two
> options:
>
> 1) Declare that any x86 hardware supported by Linux *must* support
> probing in this address region
>
> 2) Don't call probe_roms() by default, but leave it up to the graphics
> drivers. If they can get the rom by any other means then don't call it.
>

Honestly, (1) is the proper option.  Hearing that this is a prototype, I 
would like to say "fix your bloody hardware/firmware"...

The legacy region is special and will always be special, and so any 
attempts at making it non-special is a losing battle.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

