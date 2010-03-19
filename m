Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab0CSOCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 10:02:19 -0400
Received: from mga05.intel.com ([192.55.52.89]:53582 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752485Ab0CSOCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 10:02:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,274,1267430400"; 
   d="scan'208";a="782271998"
Message-ID: <4BA383E9.1040507@linux.intel.com>
Date: Fri, 19 Mar 2010 07:02:17 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: latent problem in free_init_pages()
References: <4BA35F3E0200007800035DCC@vpn.id2.novell.com>
In-Reply-To: <4BA35F3E0200007800035DCC@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/19/2010 3:25, Jan Beulich wrote:
> The calls to set_memory_rw() and set_memory_np() that both of you
> added for 2.6.25 imply that both "begin" and "end" are page aligned.
> This isn't the case, however, for the initrd and SMP locks. While at
> present this doesn't appear to do any harm, it partly subverts the
> debugging effect of the latter change and would result in a real issue
> if the .smp_locks section was moved into the read-only portion of the
> kernel image (where it really belongs imo).

if you change the linker script to move the section, you should also move it to
keep the end page aligned.

solving that at link time (like is done now) is obviously nicer than solving it at runtime ;-)
