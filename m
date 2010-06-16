Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443Ab0FPTUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 15:20:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569Ab0FPTUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 15:20:34 -0400
Message-ID: <4C1923FE.3090300@redhat.com>
Date: Wed, 16 Jun 2010 09:20:30 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/17] Fix deep C-state TSC desynchronization
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-5-git-send-email-zamsden@redhat.com> <20100616132436.GJ19104@mothafucka.localdomain>
In-Reply-To: <20100616132436.GJ19104@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 03:24 AM, Glauber Costa wrote:
> On Mon, Jun 14, 2010 at 09:34:06PM -1000, Zachary Amsden wrote:
>    
>> When CPUs with unstable TSCs enter deep C-state, TSC may stop
>> running.  This causes us to require resynchronization.  Since
>> we can't tell when this may potentially happen, we assume the
>> worst by forcing re-compensation for it at every point the VCPU
>> task is descheduled.
>>      
> can't we just compensate everytime check_tsc_unstable() is true?
>    

We should probably not rely on check_tsc_unstable, we should do this 
only if we don't have NONSTOP_TSC.
