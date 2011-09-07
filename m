Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab1IHFBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 01:01:48 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:64018 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab1IHFBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 01:01:47 -0400
X-Greylist: delayed 18350 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Sep 2011 01:01:47 EDT
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH v2] Make PTRACE_SEIZE set ptrace options specified in 'data' parameter
Date: Thu, 8 Sep 2011 00:55:51 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-11-generic; KDE/4.7.0; x86_64; ; )
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, dvlasenk@redhat.com
References: <201109072340.31460.vda.linux@googlemail.com>
In-Reply-To: <201109072340.31460.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201109080055.52232.pedro@codesourcery.com>
X-OriginalArrivalTime: 07 Sep 2011 23:55:54.0750 (UTC) FILETIME=[AE4C11E0:01CC6DB9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 September 2011 22:40:31, Denys Vlasenko wrote:
> Make PTRACE_SEIZE set ptrace options specified in 'data' parameter

(I wonder if it'd be a good idea to be more future proof and pass in
a pointer to a `struct { int my_size; int options; }', so we can
add more things in the future other than option bits, if we need to.)

> This can be used to close a few corner cases in strace where we get
> unwanted racy behavior after attach, but before we have a chance
> to set options (the notorious post-execve SIGTRAP comes to mind),

(irrespective of the patch being a good idea or not)

>From previous discussions, I understood that PTRACE_SEIZE _always_ disables
the post-execve SIGTRAP, so I don't believe that race actually exists.
Or is that not the case?

-- 
Pedro Alves
