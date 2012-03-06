Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab2CFFqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 00:46:30 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33271 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab2CFFq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 00:46:29 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ncardwell@google.com designates 10.224.196.66 as permitted sender) smtp.mail=ncardwell@google.com; dkim=pass header.i=ncardwell@google.com
MIME-Version: 1.0
In-Reply-To: <CADVnQykqaUCFBYXVqGNq+HmeowAbYJQQNpbXFpQ4Uif3gwf4ig@mail.gmail.com>
References: <alpine.DEB.2.01.1202261556150.4930@trent.utfs.org>
	<alpine.DEB.2.01.1202290929520.4930@trent.utfs.org>
	<CADVnQy=JkVc_8ptpSkhQWe4HJpbe_+JMad+2uqgN1iUfkfFFCw@mail.gmail.com>
	<CADVnQykqaUCFBYXVqGNq+HmeowAbYJQQNpbXFpQ4Uif3gwf4ig@mail.gmail.com>
Date: Tue, 6 Mar 2012 00:46:28 -0500
Message-ID: <CADVnQyk_6LYW2nyjccWjv1NmjivXf5cXBqJ+LsZLjGyOj7kddQ@mail.gmail.com>
Subject: Re: WARNING: at net/ipv4/tcp_input.c:3418
From: Neal Cardwell <ncardwell@google.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: netdev@vger.kernel.org, markus@trippelsdorf.de,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 12:41 PM, Christian Kujau <lists@nerdbynature.de> wrote:
> This is still happening with 3.3.0-rc5, .config & dmesg here:
>
>   http://nerdbynature.de/bits/3.3.0-rc4/ipv4/

I was finally able to reproduce this issue where there are warnings
about sacked_out going negative (since 3.3.0-rc4), and my testing
shows that this patch seems to fix the issue:

  http://patchwork.ozlabs.org/patch/144844/

For folks who were seeing this problem and are so inclined, feel free
to try the latest 3.3-rc6 kernel (or davem's "net" tree in git, if
that's easier) with that patch applied, and let me know how it goes.

thanks,
neal
