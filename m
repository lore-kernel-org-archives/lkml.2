Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491Ab2EIOQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:16:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758294Ab2EIOQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:16:10 -0400
Message-ID: <4FAA7C06.1060209@redhat.com>
Date: Wed, 09 May 2012 16:15:34 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120425 Thunderbird/12.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Jarkko Sakkinen <jarkko.sakkinen@intel.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>
Subject: Re: [PATCH 04/23] x86, realmode: Move reboot_32.S to unified realmode
 code
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com> <1336501366-28617-5-git-send-email-jarkko.sakkinen@intel.com> <4FAA18F1.6080508@redhat.com> <alpine.DEB.2.02.1205091525100.6943@jsakkine-mobl2.(null)> <4FAA76E7.1070807@linux.intel.com>
In-Reply-To: <4FAA76E7.1070807@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 09/05/2012 15:53, H. Peter Anvin ha scritto:
>> > It's true that it doesn't matter much but still it is a
>> > regression. And it doesn't cause any kind of overhead
>> > or bloat to fix this.
>> > 
> However, the big thing is that we jump to the BIOS with caches off.  I
> personally think it is the wrong thing to do (we don't jump to the real
> reset vector anyway) but it is what has been tested for a long time.

I'm not sure I understand.  The code has

	andl	$0x60000000, %edx	; clear ET/PE
	jz	2f
	...
2:
	andb	$0x10, %dl		; clear CD/WT, %edx is always 0


What I've suggested is:

	testl	$0x60000000, %edx
	jz	2f
	...
2:
	andb	$0x10, %dl		; clear PE only


What would jump to the BIOS with caches on is:

	testl	$0x60000000, %edx
	jz	2f
	...
2:
	andl	$0x10, %edx		; Clear CD/WT/PE


Am I missing something?

Paolo
