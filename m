Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab1GZRY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 13:24:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab1GZRYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 13:24:51 -0400
Message-ID: <4E2EF851.8060202@redhat.com>
Date: Tue, 26 Jul 2011 20:24:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Vasiliy Kulikov <segooon@gmail.com>, Jan Kiszka <jan.kiszka@web.de>,
        kernel-janitors@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2] x86: kvm: x86: fix information leak to userland
References: <1288447871-7715-1-git-send-email-segooon@gmail.com> <4CCC2D11.7090109@web.de> <20101030153147.GA14169@albatros> <4CCC3DC2.6090505@web.de> <20101030185447.GA7629@albatros> <ABD7343A-6440-4CC0-B8B0-9D27EF0291B0@suse.de>
In-Reply-To: <ABD7343A-6440-4CC0-B8B0-9D27EF0291B0@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 08:05 PM, Alexander Graf wrote:
> struct kvm_pit_state2 {
>          struct kvm_pit_channel_state channels[3];
>          __u32 flags;
>          __u32 reserved[9];
> };
>
> So memset(&ps->reserved) would give you the a __u32 **, no? Same goes for all the other array sets in here. Or am I understanding some C logic wrong? :)
>

An address of an array is the array itself.

-- 
error compiling committee.c: too many arguments to function

