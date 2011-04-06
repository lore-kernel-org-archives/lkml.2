Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab1DFEqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 00:46:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34405 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab1DFEqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 00:46:38 -0400
Message-ID: <4D9BEFF6.1030907@zytor.com>
Date: Tue, 05 Apr 2011 21:45:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Ingo Molnar <mingo@elte.hu>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        "lkml20101129@newton.leun.net" <lkml20101129@newton.leun.net>,
        stable kernel team <stable@kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH urgent] x86: Save cr4 to mmu_cr4_features at boot time
References: <alpine.DEB.2.00.1103311715400.16492@kaball-desktop> <201104050843.39246.rjw@sisk.pl> <4D9BA9FA.4010405@zytor.com> <201104060634.12555.rjw@sisk.pl>
In-Reply-To: <201104060634.12555.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2011 09:34 PM, Rafael J. Wysocki wrote:
> 
> Do you mean during resume?
> 
> I think we can try to make the ordering more appropriate, but I'm not really
> sure it would be a good idea to do that in the same patch.  Probably not.
> 
> Also, our current ordering has never been reported to cause problems to anyone.
> 

Yes, I mean on resume.

I'm not sure if we'd know since it would manifest as a very early failure.

Anyway, agreed it's not the same patch.

Two things:

1. Do you agree that this is the right place to put this?  There seems
to be some other things in __save_processor_state() which puts things in
places outside struct saved_context, but I would like your opinion.

2. While we're at it, why is mtrr_save_fixed_ranges() only called on x86-32?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

