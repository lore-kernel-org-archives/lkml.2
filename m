Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1BBT5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 14:57:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56927 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab1BBT5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 14:57:22 -0500
Message-ID: <4D49B707.8000003@zytor.com>
Date: Wed, 02 Feb 2011 11:56:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH] Fix EDD3.0 data verification.
References: <20110202112139.GD14984@redhat.com> <4D4990F8.5020204@zytor.com> <20110202172534.GA24871@redhat.com> <4D49946D.8010800@zytor.com> <20110202173827.GB24871@redhat.com> <20110202175944.GC24871@redhat.com>
In-Reply-To: <20110202175944.GC24871@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2011 09:59 AM, Gleb Natapov wrote:
> 
> Ah I see what length you were referring to params->device_path_info_length.
> If we will use that then we will get correct checksum for BIOSes that work
> according to phoenix spec too, but edd_show_interface() and edd_show_host_bus()
> handle only T13 spec so the information they show can be incorrect. I can
> change code to check that params->device_path_info_length == 44 in addition
> to checking csum. What do you think?
> 

Yes, you need to check both.

This is really a union of two similar-but-not-identical structures
distinguished by the length field.

	-hpa
