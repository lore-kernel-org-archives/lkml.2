Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab0FPHca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 03:32:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47032 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab0FPHc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 03:32:29 -0400
Message-ID: <4C187DF1.9030007@zytor.com>
Date: Wed, 16 Jun 2010 00:32:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Really lazy fpu
References: <1276441427-31514-1-git-send-email-avi@redhat.com> <4C187C22.2080505@redhat.com>
In-Reply-To: <4C187C22.2080505@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 12:24 AM, Avi Kivity wrote:
> 
> Ingo, Peter, any feedback on this?
> 

Conceptually, this makes sense to me.  However, I have a concern what
happens when a task is scheduled on another CPU, while its FPU state is
still in registers in the original CPU.  That would seem to require
expensive IPIs to spill the state in order for the rescheduling to
proceed, and this could really damage performance.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

