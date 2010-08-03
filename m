Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab0HCPsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:48:55 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40756 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271Ab0HCPsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:48:51 -0400
Date: Tue, 3 Aug 2010 17:49:01 +0200
From: Borislav Petkov <bp@amd64.org>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: 2.6.35 hangs on early boot in KVM
Message-ID: <20100803154901.GF28136@aftab>
References: <201008031028.57263.tvrtko.ursulin@sophos.com>
 <201008031557.04613.tvrtko.ursulin@sophos.com>
 <201008031617.21418.tvrtko.ursulin@sophos.com>
 <201008031631.03111.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008031631.03111.tvrtko.ursulin@sophos.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Date: Tue, Aug 03, 2010 at 11:31:02AM -0400

> > One interesting waning spotted:
> >
> > include/config/auto.conf:555:warning: symbol value '-fcall-saved-ecx
> > -fcall- saved-edx' invalid for ARCH_HWEIGHT_CFLAGS
> 
> Copying Peter and Borislav, guys please look at the above warning. I am
> bisecting a non-bootable 2.6.35 under KVM and while I am not there yet, it is
> close to the hweight commit (cb41838bbc4403f7270a94b93a9a0d9fc9c2e7ea) and I
> spotted this warning.

That's because you're at a bisection point before the hweight patch but
your .config already contains the ARCH_HWEIGHT_CFLAGS variable because
of the previous bisection point which contained the hweight patch.

I think this can be safely ignored.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
