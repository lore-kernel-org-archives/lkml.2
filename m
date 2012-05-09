Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507Ab2EIOSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:18:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:24548 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757213Ab2EIOSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:18:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150988224"
Message-ID: <4FAA7C9A.2060808@linux.intel.com>
Date: Wed, 09 May 2012 07:18:02 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Jarkko Sakkinen <jarkko.sakkinen@intel.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>
Subject: Re: [PATCH 04/23] x86, realmode: Move reboot_32.S to unified realmode
 code
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com> <1336501366-28617-5-git-send-email-jarkko.sakkinen@intel.com> <4FAA18F1.6080508@redhat.com> <alpine.DEB.2.02.1205091525100.6943@jsakkine-mobl2.(null)> <4FAA76E7.1070807@linux.intel.com> <4FAA7C06.1060209@redhat.com>
In-Reply-To: <4FAA7C06.1060209@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 07:15 AM, Paolo Bonzini wrote:
> 
> I'm not sure I understand.  The code has
> 
> 	andl	$0x60000000, %edx	; clear ET/PE
> 	jz	2f
> 	...
> 2:
> 	andb	$0x10, %dl		; clear CD/WT, %edx is always 0
> 
> 
> What I've suggested is:
> 
> 	testl	$0x60000000, %edx
> 	jz	2f
> 	...
> 2:
> 	andb	$0x10, %dl		; clear PE only
> 
> 
> What would jump to the BIOS with caches on is:
> 
> 	testl	$0x60000000, %edx
> 	jz	2f
> 	...
> 2:
> 	andl	$0x10, %edx		; Clear CD/WT/PE
> 
> 
> Am I missing something?
> 

Not awake yet, sorry...

	-hpa


