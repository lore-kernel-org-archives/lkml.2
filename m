Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab1JKXou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 19:44:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56628 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab1JKXot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 19:44:49 -0400
Message-ID: <4E94D4E7.5010001@zytor.com>
Date: Tue, 11 Oct 2011 16:44:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/1] x86, e820: Remove direct mapping of reserved space
 for HT hole around 1TB
References: <1318370975-10817-1-git-send-email-jacob.shin@amd.com>
In-Reply-To: <1318370975-10817-1-git-send-email-jacob.shin@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2011 03:09 PM, Jacob Shin wrote:
> The entire HT hole and also the unused address range before that hole
> need to be excluded from direct mapping. Otherwise speculative
> accesses to that reserved region can happen which cause machine
> checks.

BARF!

This is completely insane ad hockery when all that really should need to 
happen is marking the HT region RESERVED, which should be possible on 
any HT-equipped processor.

	-hpa

