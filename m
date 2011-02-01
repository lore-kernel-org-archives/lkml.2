Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab1BAQtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:49:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab1BAQtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:49:12 -0500
Message-ID: <4D483954.20600@redhat.com>
Date: Tue, 01 Feb 2011 11:48:20 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi@redhat.com, mtosatti@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Allow GUP to fail instead of waiting on a page.
References: <1296559307-14637-1-git-send-email-gleb@redhat.com> <1296559307-14637-2-git-send-email-gleb@redhat.com>
In-Reply-To: <1296559307-14637-2-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 06:21 AM, Gleb Natapov wrote:
> GUP user may want to try to acquire a reference to a page if it is already
> in memory, but not if IO, to bring it in, is needed. For example KVM may
> tell vcpu to schedule another guest process if current one is trying to
> access swapped out page. Meanwhile, the page will be swapped in and the
> guest process, that depends on it, will be able to run again.
>
> This patch adds FAULT_FLAG_RETRY_NOWAIT (suggested by Linus) and
> FOLL_NOWAIT follow_page flags. FAULT_FLAG_RETRY_NOWAIT, when used in
> conjunction with VM_FAULT_ALLOW_RETRY, indicates to handle_mm_fault that
> it shouldn't drop mmap_sem and wait on a page, but return VM_FAULT_RETRY
> instead.
>
> Signed-off-by: Gleb Natapov<gleb@redhat.com>
> CC: Linus Torvalds<torvalds@linux-foundation.org>
> CC: Rik van Riel<riel@redhat.com>
> CC: Hugh Dickins<hughd@google.com>
> CC: Andrew Morton<akpm@linux-foundation.org>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
