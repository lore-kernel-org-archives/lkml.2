Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab2E3QbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 12:31:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40006 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab2E3QbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 12:31:10 -0400
Message-ID: <4FC64B3E.2020002@zytor.com>
Date: Wed, 30 May 2012 09:30:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Steven Newbury <steve@snewbury.org.uk>, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org> <CAE9FiQXvYH4zCqp_uOb2nw7jvm8B=q3yx1tCjJUT+PkdymYEuw@mail.gmail.com> <CAE9FiQW0rm2_sKdSCWs3TfatJB9yHwvmvt9_vBYMtOq_YBbmfw@mail.gmail.com> <20120525193716.GA8817@google.com> <CAE9FiQWrZaBpT1fzC_-mSBfDd4AKGrdGomPxVNSU-SFPrVNvOw@mail.gmail.com> <CAErSpo7d+zn-qgWKcbro7yneXRtmZQCOHi+kiGzYUTfs+aiF4g@mail.gmail.com> <CAE9FiQUWWO75WP3gYRwYbyO_ZiWwyjKnzMxOGhfjY4H98w2Hbw@mail.gmail.com> <CAErSpo46fCCFCijNfMzGYP__pP6hkPFurMS=1=wSAZsg5z0-Lg@mail.gmail.com> <CAE9FiQWUrkKEpLmEn9kzkKOtEtX7-R8shdVSKGgSyHezKpzJCw@mail.gmail.com> <4FC50E09.4000204@zytor.com> <CAE9FiQUtio=dut3A9+jCcsgUWEeNYcpqLP6RpqGOZUfPPAtHWw@mail.gmail.com> <CAErSpo4ywho4UmPVAjT7yZNROc9e1zCx+UoaS5un+v4aN=akJA@mail.gmail.com> <CAE9FiQWORRjxEQwr+933ReNAAKAEoJ5B6AWte4gr33_BO+4heQ@mail.gmail.com> <CAErSpo44TViNFcZivjr5hAu8w8kpEpUjxNAWtazhAqwwsorZbw@mail.gmail.com> <4FC5CEF1.6000509@snewbury.org.uk> <CAErSpo6zU898KBv+vFFkymMjpDrPokj0dJq9MMX0z6WZOALbmQ@mail.gmail.!
 com>
In-Reply-To: <CAErSpo6zU898KBv+vFFkymMjpDrPokj0dJq9MMX0z6WZOALbmQ@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 09:27 AM, Bjorn Helgaas wrote:
> 
> You're right, the spec does allow the upper 16 bits of I/O BARs to be
> hardwired to zero (PCI spec rev 3.0, p. 226), so this part does make
> some sense.  I don't think it applies to x86, since I don't think
> there's a way to generate an I/O access to anything above 64K, but it
> could help other arches.
> 
> I'm inclined to be conservative and wait until we find a problem where
> a patch like this would help.
> 

The really conservative thing is to just use 16-bit addresses for I/O on
all platforms.  I think a lot of non-x86 platforms does that.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

