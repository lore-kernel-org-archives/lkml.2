Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab1CMNkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 09:40:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:53393 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605Ab1CMNkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 09:40:04 -0400
Message-ID: <4D7CC931.1090204@suse.cz>
Date: Sun, 13 Mar 2011 14:40:01 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] genksyms: Track changes to enum constant
References: <1299997825-18977-1-git-send-email-mmarek@suse.cz> <20110313071902.GA3377@merkur.ravnborg.org>
In-Reply-To: <20110313071902.GA3377@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.3.2011 08:19, Sam Ravnborg wrote:
> Hi Michal.
> 
> Patch serie looks good.
> You can add my ack to all of them if you do a second round.

Thanks.


> On Sun, Mar 13, 2011 at 07:30:18AM +0100, Michal Marek wrote:
>> This series makes genksyms remember the values of enum constants and use them
>> during symbol expansion. This makes sure that patches like
>>
>> | enum e {
>> |  	E1,
>> | 	E2,
>> |+	E3,
>> | 	E_MAX
>> | };
>> |
>> | struct s {
>> | 	int a[E_MAX];
>> | }
>> |
>> | int f(struct s *s) { ... }
>> | EXPORT_SYMBOL(f)
>>
>> change the checksum of the exported symbol. Previously, it would just use the
>> string "E_MAX" in the calculation and the change would go unnoticed. The main
>> part is in patches 6/7 and 7/7, the rest are cleanups and preparatory patches.
> 
> This nice explanation would be good to include in the changelog
> of 7/8 so "git log" give a better intro to the changes.

Good idea, I'll update the patch description.

Michal
