Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab0FRIVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 04:21:12 -0400
Received: from t111.niisi.ras.ru ([193.232.173.111]:59394 "EHLO
	t111.niisi.ras.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491Ab0FRIVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 04:21:10 -0400
X-Greylist: delayed 2278 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jun 2010 04:21:09 EDT
Message-ID: <4C1B263E.7070906@niisi.msk.ru>
Date: Fri, 18 Jun 2010 11:54:38 +0400
From: "Gleb O. Raiko" <raiko@niisi.msk.ru>
Organization: NIISI RAN
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: Jesper Nilsson <jesper@jni.nu>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: MIPS: return after handling coprocessor 2 exception
References: <20100617132554.GB24162@jni.nu> <4C1A57AE.9080706@caviumnetworks.com>
In-Reply-To: <4C1A57AE.9080706@caviumnetworks.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: Dr.Web (R) for Mail Servers on t111.niisi.ras.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.06.2010 21:13, David Daney wrote:
> On 06/17/2010 06:25 AM, Jesper Nilsson wrote:
>> Breaking here dropped us to the default code which always sends
>> a SIGILL to the current process, no matter what the CU2 notifier says.
>>
>> Signed-off-by: Jesper Nilsson<jesper@jni.nu>
[...]
>> case 2:
>> raw_notifier_call_chain(&cu2_chain, CU2_EXCEPTION, regs);
>> - break;
>> + return;
>>
>
> What happens when the call chain is empty, and the proper action *is*
> SIGILL?

It's never empty, in fact. The default notifier declared at top of 
traps.c sends SIGILL. The problem that current code is sending SIGILL in 
all cases.

Gleb.
