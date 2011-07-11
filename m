Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab1GKNYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:24:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217Ab1GKNY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:24:27 -0400
Message-ID: <4E1AF970.8030109@redhat.com>
Date: Mon, 11 Jul 2011 10:24:00 -0300
From: Glauber Costa <glommer@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Eddie Dong <eddie.dong@intel.com>, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>, tony.luck@intel.com,
        fenghua.yu@intel.com, xiantao.zhang@intel.com
Subject: Re: [PATCH v5 6/9] add jump labels for ia64 paravirt
References: <1309793548-16714-1-git-send-email-glommer@redhat.com> <1309793548-16714-7-git-send-email-glommer@redhat.com> <4E1AF612.7040103@redhat.com>
In-Reply-To: <4E1AF612.7040103@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2011 10:09 AM, Avi Kivity wrote:
> On 07/04/2011 06:32 PM, Glauber Costa wrote:
>> Since in a later patch I intend to call jump labels inside
>> CONFIG_PARAVIRT, IA64 would fail to compile if they are not
>> provided. This patch provides those jump labels for the IA64
>> architecture.
>>
>
> Please get an ack for this from the ia64 maintainer.
>

The ones listed in paravirt.c are CC'd. I am CC'ing all the other
folks related to IA64 listed in MAINTAINERS now.

Just a heads up so the new folks CC'd can get up to speed:
I am proposing moving the steal time calculation to inside the core 
scheduler. This move will make it easier for us to make decisions based 
on steal time accounting on virtual machines. Ia64 KVM may or may not 
follow this route - nothing that already works should break with this 
change.

This patch is needed only to avoid breaking compilation, since it 
introduces two new variables that are expected be present when 
CONFIG_PARAVIRT, to paravirt.c.

