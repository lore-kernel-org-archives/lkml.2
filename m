Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab1K1FHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 00:07:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab1K1FHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 00:07:22 -0500
Message-ID: <4ED316F4.20709@redhat.com>
Date: Mon, 28 Nov 2011 13:07:00 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Cesar Eduardo Barros <cesarb@cesarb.net>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Nick Bowler <nbowler@elliptictech.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 01/62] highmem: mark k[un]map_atomic() with two arguments
 as deprecated
References: <1322371662-26166-1-git-send-email-amwang@redhat.com> <1322371662-26166-2-git-send-email-amwang@redhat.com> <4ED22E3E.8080507@cesarb.net>
In-Reply-To: <4ED22E3E.8080507@cesarb.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月27日 20:34, Cesar Eduardo Barros 写道:
>
> This will break the misuse detection of kunmap_atomic (see commit 597781f3e51f48ef8e67be772196d9e9673752c4).
>
> kunmap_atomic() _must_ be a macro, so the __same_type can see the type the caller used. If you use an inline function, all it will see is a void *, even if the caller confused it with kunmap() and passed a struct page *.
>

Hmm, I think you are right, I will switch it back to a macro.

Thanks for review!
