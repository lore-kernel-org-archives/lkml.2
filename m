Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab1JXHq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 03:46:56 -0400
Received: from smtpbg55.qq.com ([64.71.138.44]:37466 "HELO smtpbg55.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753436Ab1JXHqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 03:46:55 -0400
X-QQ-mid: esmtp12t1319442328t107t28874
X-QQ-SSF: 000000000000000020K001000000000
Message-ID: <4EA517D7.6060407@qq.com>
Date: Mon, 24 Oct 2011 15:46:31 +0800
From: Xiao Guangrong <xiao.guangrong@qq.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Zhao Jin <cronozhj@gmail.com>
CC: avi@redhat.com, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: MMU: fix the condition of syncing a new shadow page
References: <1319440880-2610-1-git-send-email-cronozhj@gmail.com> <1319440880-2610-2-git-send-email-cronozhj@gmail.com>
In-Reply-To: <1319440880-2610-2-git-send-email-cronozhj@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011/10/24 15:21, Zhao Jin wrote:
> Should be "or" since a new shadow page is synced if either it is
> not leaf or there already exists another unsync shadow page with 
> the same gfn.
> 

It is obviously wrong, we need to sync pages only if it has unsync page
*and* the new shadow page breaks the unsync rule(only the level 1 sp can
became unsync).
