Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab2FYHFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 03:05:22 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:40760 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab2FYHFV convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 25 Jun 2012 03:05:21 -0400
Message-Id: <4FE829CD020000780008B9DB@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 25 Jun 2012 08:05:17 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Kay Sievers" <kay@vrfy.org>
Cc: <yuanhan.liu@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] syslog: fill buffer with more than a single
 message for SYSLOG_ACTION_READ
References: <4FE4AD09020000780008B77F@nat28.tlf.novell.com>
 <CAPXgP13nd7k3v3YGcW9F45L8LhT5tctw64jaooUwQ8=ypfVH+g@mail.gmail.com>
In-Reply-To: <CAPXgP13nd7k3v3YGcW9F45L8LhT5tctw64jaooUwQ8=ypfVH+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 23.06.12 at 20:03, Kay Sievers <kay@vrfy.org> wrote:
>> Furthermore, this patch also addresses the problem dealt with in
>> commit 4a77a5a06ec66ed05199b301e7c25f42f979afdc ("printk: use mutex
>> lock to stop syslog_seq from going wild"), so I'd recommend reverting
>> that one too (albeit there's no direct collision between the two).
> 
> Are you sure that is covered? Doesn't the other thread would just
> return 0 to the caller then, instead of continuing to stay in the
> syscall when the first thread got the message?

The old code permitted returning zero in that case too, so I don't
see why the new code shouldn't be allowed to. But anyway, as
said this patch doesn't directly conflict, and hence it's up to the
maintainer(s) of the code to decide whether to keep it. The
conflicting one, however, imo ought to be reverted in any case.

Jan

