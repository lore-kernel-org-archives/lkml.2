Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0EZObi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 10:31:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753290Ab0EZObh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 10:31:37 -0400
Date: Wed, 26 May 2010 07:30:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: adobriyan@gmail.com, nhorman@tuxdriver.com, oleg@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 10/11] rlimits: implement prlimit64 syscall
Message-Id: <20100526073045.ea26740f.akpm@linux-foundation.org>
In-Reply-To: <4BFD1ADD.7020004@gmail.com>
References: <1273514451-28894-1-git-send-email-jslaby@suse.cz>
	<1273514451-28894-10-git-send-email-jslaby@suse.cz>
	<20100513155630.9ca5ab16.akpm@linux-foundation.org>
	<4BFD1ADD.7020004@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 14:58:05 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:

> > This could all be done in userspace, couldn't it?  Write a little library
> > which clones a thread then waits for someone to send it a
> > change-your-rlimits message.  Write a little tool to send those
> > messages and voila.
> 
> Sorry, I'm not sure I understand this. Could you shed some light on what
> will run in the new thread?
> 
> A code such as:
> main()
> {
>   if (!clone())
>     exec("something");
> 
>   while (wait_for_message(&m)) {
>      setrlimit(m);
>      sleep();
>   }
> }
> won't obviously work. Could you change it so it reflects your idea or
> explain what I'm missing?

main()
{
	if (clone(...)) {
		while (wait_for_message(&m))
			setrlimit(m);
	}

	...
}
		
?
