Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab1DZQDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:03:47 -0400
Received: from mout.perfora.net ([74.208.4.194]:54228 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab1DZQDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:03:46 -0400
Date: Tue, 26 Apr 2011 12:03:00 -0400
From: Stephen Wilson <wilsons@start.ca>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>, bookjovi@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] proc: put check_mem_permission before __get_free_page
	in mem_read
Message-ID: <20110426160300.GA14478@fibrous.localdomain>
References: <1303086002-6961-1-git-send-email-bookjovi@gmail.com> <alpine.LSU.2.00.1104252048190.6978@sister.anvils> <20110426141449.F37C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426141449.F37C.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:+lub/nYaYwwdgPOYhrtwRbC5HEQaB/gVJ8zHyVf4ZCm
 /Oft5Mz5V3n6BOiJquMVDZU+uywZPAHEIunqAAOvdKRWWD2ygU
 I4a97TIYovo4imuPdN62dh5oSZP8+QCHMsrrHV3PlHoBQRSv9R
 fzSTmzg3J9hWGq6i7NIkMGz3YQYO3/DcjNts2orISFbs65RTuz
 4DlVTFpwaeEaQvOT7fDWwckrPQEEUZSKaPgHxBhx6g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 02:12:46PM +0900, KOSAKI Motohiro wrote:
> From 74f827ce74e1c4f846905e940edfa5f639b5a2ce Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Tue, 26 Apr 2011 13:57:02 +0900
> Subject: [PATCH] [PATCH] proc: put check_mem_permission after __get_free_page in mem_write
> 
> It should be better if put check_mem_permission after __get_free_page
> in mem_write, to be same as function mem_read.
> 
> Hugh Dickins explained the reason.
> 
>     check_mem_permission gets a reference to the mm.  If we __get_free_page
>     after check_mem_permission, imagine what happens if the system is out
>     of memory, and the mm we're looking at is selected for killing by the
>     OOM killer: while we wait in __get_free_page for more memory, no memory
>     is freed from the selected mm because it cannot reach exit_mmap while
>     we hold that reference.
> 
> 
> Reported-by: Jovi Zhang <bookjovi@gmail.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Stephen Wilson <wilsons@start.ca>


I completely missed the oom case as well.  This certainly appears to be
the best solution.

	Reviewed-by: Stephen Wilson <wilsons@start.ca>

-- 
steve

