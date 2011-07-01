Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1GACxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 22:53:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486Ab1GACxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 22:53:32 -0400
Message-ID: <4E0D369C.4090403@redhat.com>
Date: Thu, 30 Jun 2011 23:53:16 -0300
From: Glauber Costa <glommer@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH v3 7/9] KVM-GST: KVM Steal time accounting
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>	 <1309361388-30163-8-git-send-email-glommer@redhat.com> <1309470869.12449.607.camel@twins>
In-Reply-To: <1309470869.12449.607.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2011 06:54 PM, Peter Zijlstra wrote:
> On Wed, 2011-06-29 at 11:29 -0400, Glauber Costa wrote:
>> +       if (static_branch(&paravirt_steal_enabled)) {
>
> How is that going to compile on !CONFIG_PARAVIRT or !x86 in general?
> Only x86-PARAVIRT will provide that variable.
>
>

Good point. I'd wrap it into CONFIG_PARAVIRT.
To be clear, the reason I did not put it inside 
CONFIG_PARAVIRT_TIME_ACCOUNTING, is because I wanted to have the mere 
display of steal time separated from the rest - unless, of course, you 
object this idea.

Using CONFIG_PARAVIRT achieves this goal well.
