Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab2DBOtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:49:25 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:34302 "EHLO
	homiemail-a79.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751047Ab2DBOtX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 10:49:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=dl+g8nGRDrUSG/N61BRsveaE5iI+BknUmDJwXtIbaD3ZBBUs+Lx9KvnCm5LCh
	Vzwfdbr5z3Is/cSOn0Ufhp0DEu0wFlchQRiydQqinHNQXLIFPQ1NfY2H7VeSre3l
	iSsdXWzqYFEqPsdiuetORP0vxbqmwZbp2pH8cWepNDDHaI=
Message-ID: <4F79BC66.3010902@shealevy.com>
Date: Mon, 02 Apr 2012 10:49:10 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120321 Thunderbird/11.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Llu=EDs_Batlle_i_Rossell?= <viric@viric.name>
CC: linux-kernel@vger.kernel.org
Subject: Re: Hang opening a pipe written to by a child, with SIGCHLD
References: <20120402144611.GY3029@vicerveza.homeunix.net>
In-Reply-To: <20120402144611.GY3029@vicerveza.homeunix.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 10:46 AM, Lluís Batlle i Rossell wrote:
> Hello,
>
> I had troubles running a simple bash script where a child wrote to a named pipe
> before dying, and the parent opened and read the pipe.
>
> On a computer, my script hangs always. Also under 'strace'. Not under 'strace
> -f'. Thinking of some race, I wrote a small script that hangs in the linuxes I
> could try (3.2.11 now):
>
> ----------
> #!/var/run/current-system/sw/bin/bash
>
> PIPE=/tmp/pipe
>
> rm -f $PIPE
> mkfifo $PIPE
>
> function spawn {
>      echo DONE>  $PIPE
> }
>
> spawn sleep 1&
>
> while true; do
>      echo reading
>      while read LINE<  $PIPE; do
>          echo $LINE
>          spawn&
>      done
> done
> -------------
>
> bash uses SA_RESTART on SIGCHLD handler, and nevertheless the script halts at
> printing some amount of 'DONE'. Strace shows it's inside the open() call, while the open
> call has been interrupted by SIGCHLD. One of the computers I have hangs at the *first* DONE always, and that's why it's annoying to me.
>
> Can anyone reproduce this?

I've reproduced this on my system as well (3.3). No idea about cause though.

~Shea
