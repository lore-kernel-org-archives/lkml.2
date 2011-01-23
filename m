Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751092Ab1AWAtk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 19:49:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57151 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1AWAtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 19:49:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=InkB1wVJaNH7Oz9SmFWqBL27V8Ky/yYkjbdiCRAHve3SG6mG7/4iJIeakw5DSODdYG
         k+v9BHqX/+WUHIxYzh/Bs9iK40G5WS2FN7Jm90408bzmhJdoLeBXQn5s+dkILlZ5+qQm
         ugj5pmQlUqxNlge8UHN88OtCohjm9z5I9/ZqA=
MIME-Version: 1.0
Date: Sat, 22 Jan 2011 19:49:37 -0500
Message-ID: <AANLkTimCMnjBM5naA1Wzb_FiW7bsVcb1DRyffTizDp_Z@mail.gmail.com>
Subject: How does CFQ handle the fairness of process write
From: Yuehai Xu <yuehaixu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, yhxu@wayne.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Suppose there are two processes writing lots of data to disk, these
data are written to cache at first, and then, kernel threads might
flush them to disk later. However, from the point of block device, the
kernel thread is just another process that issues write requests. So,
how does CFQ handle the fairness between the two processes? It is
impossible for CFQ to keep the fairness of the two queues for each
process since many write requests are dispatched by kernel thread,
which has another queue in CFQ. And both the requests from two
processes are mixed together in this kernel thread queue.

Is this description correct? In that case, how does CFQ keep the
fairness for two processes since CFQ seems unable to know the exact
process the request belongs to.

I appreciate your help.

Thanks,
Yuehai
