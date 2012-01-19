Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab2ASPKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 10:10:08 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34086 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab2ASPKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 10:10:06 -0500
Message-ID: <4F18323D.2000109@gmail.com>
Date: Thu, 19 Jan 2012 23:09:49 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Tyler Hicks <tyhicks@canonical.com>
CC: Li Wang <liwang@nudt.edu.cn>, ecryptfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yunchuan Wen <wenyunchuan@kylinos.com.cn>
Subject: Re: [PATCH] eCryptfs: infinite loop due to overflow in ecryptfs_write()
References: <12011909443668a7a65ff897afc93db177848236f08f@nudt.edu.cn> <1326964413-8529-1-git-send-email-tyhicks@canonical.com>
In-Reply-To: <1326964413-8529-1-git-send-email-tyhicks@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 05:13 PM, Tyler Hicks wrote:
> From: Li Wang<liwang@nudt.edu.cn>
>
> ecryptfs_write() can enter an infinite loop when truncating a file to a
> size larger than 4G. This only happens on architectures where size_t is
> represented by 32 bits.
>
> This was caused by a size_t overflow due to it incorrectly being used to
> store the result of a calculation which uses potentially large values of
> type loff_t.
>
> [tyhicks@canonical.com: rewrite subject and commit message]
> Signed-off-by: Li Wang<liwang@nudt.edu.cn>
> Signed-off-by: Yunchuan Wen<wenyunchuan@kylinos.com.cn>
> Cc: Cong Wang<xiyou.wangcong@gmail.com>
> Cc:<stable@vger.kernel.org>
> Signed-off-by: Tyler Hicks<tyhicks@canonical.com>


Tyler, thanks for cleaning this up! Looks pretty good now.
