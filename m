Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab1HPU1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 16:27:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33183 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab1HPU1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 16:27:54 -0400
Message-ID: <4E4AD2C5.6080205@lwfinger.net>
Date: Tue, 16 Aug 2011 15:27:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8712: remove r8712_cmd_thread()->daemonize()
References: <20110816185057.GA4036@redhat.com> <20110816193543.GD2803@mtj.dyndns.org>
In-Reply-To: <20110816193543.GD2803@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2011 02:35 PM, Tejun Heo wrote:
> On Tue, Aug 16, 2011 at 08:50:57PM +0200, Oleg Nesterov wrote:
>> daemonize() is only needed when a user-space task does kernel_thread().
>>
>> r8712_cmd_thread() is kthread_create()'ed and thus it doesn't need
>> the soon-to-be-deprecated daemonize(). It is the only caller of
>> thread_enter() which actually does the call.
>>
>> Note:
>> 	- we are going to remove the sigdelset(blocked) code from
>> 	  allow_signal(), this means that without this patch
>> 	  thread_enter() can't work after that. Not to mention
>> 	  daemonize() should be deprecated.
>>
>> 	- as a side effect, this patch changes ->comm. Hopefully
>> 	  this is fine, and padapter->pnetdev->name probably makes
>> 	  more sense anyway.
>>
>> Signed-off-by: Oleg Nesterov<oleg@redhat.com>
>
> Acked-by: Tejun Heo<tj@kernel.org>
Acked-and-tested-by: Larry Finger <Larry.Finger@lwfinger.net>
