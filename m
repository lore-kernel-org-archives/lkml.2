Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab1C2QCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 12:02:41 -0400
Received: from smtpbg55.qq.com ([64.71.138.44]:55371 "HELO smtpbg55.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751630Ab1C2QCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 12:02:39 -0400
X-QQ-mid: esmtp5t1301414414t708t10031
X-QQ-SSF: 00000000000000F0FG400F000000000
Date: Wed, 30 Mar 2011 00:00:16 +0800
From: "Lina Lu" <lulina_nuaa@foxmail.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Cc: "linux kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: Blkio: Apply two policies on one IO process
Message-ID: <201103300000153595438@foxmail.com>
X-mailer: Foxmail 6, 15, 201, 23 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
      As the weight and throttle policies are on different layers, someone can apply 
these two policies on one IO pid at one time. And the IO bandwidth will be controlled
with the more stringent policy.
      If someone first set two policies on one pid, then want to remove the weight
policy, he must first echo the pid to parent dir's tasks, then echo the throttle policy
to parent dir's blkio.throttle_xx_xx_device. These steps seen to be cumbersome.
      This is because the weight policy can be applied independence, but the throttle
policy is always accompany with the weight policy(default 500). I think it will be 
better that these policies are independent of each other. What is your opinion?
      Additional, do you recommend applying two policies on one IO process?

Thanks
Lina

