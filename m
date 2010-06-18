Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183Ab0FRKYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 06:24:17 -0400
Received: from t111.niisi.ras.ru ([193.232.173.111]:34968 "EHLO
	t111.niisi.ras.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759218Ab0FRKYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 06:24:15 -0400
Message-ID: <4C1B4C0A.9070506@niisi.msk.ru>
Date: Fri, 18 Jun 2010 14:35:54 +0400
From: "Gleb O. Raiko" <raiko@niisi.msk.ru>
Organization: NIISI RAN
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: David Daney <ddaney@caviumnetworks.com>, Jesper Nilsson <jesper@jni.nu>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: MIPS: return after handling coprocessor 2 exception
References: <20100617132554.GB24162@jni.nu> <4C1A57AE.9080706@caviumnetworks.com> <4C1B263E.7070906@niisi.msk.ru> <20100618100053.GA4466@linux-mips.org>
In-Reply-To: <20100618100053.GA4466@linux-mips.org>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: Dr.Web (R) for Mail Servers on t111.niisi.ras.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.06.2010 14:00, Ralf Baechle wrote:
> static int default_cu2_call(struct notifier_block *nfb, unsigned long action,
>          void *data)
> {
> 	...
>
> 	return NOTIFY_OK | NOTIFY_STOP;
NOTIFY_STOP implies NOTIFY_OK, so
	return NOTIFY_STOP;
shall be enough.
> }

> The notifier list could also be used for example by perf

Or octeon cop2 handler that just sends NOTIFY_BAD for getting the same 
behavior.

Gleb.
