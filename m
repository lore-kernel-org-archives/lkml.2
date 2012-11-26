Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab2KZXi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:38:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:39034 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796Ab2KZXi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:38:26 -0500
Date: Mon, 26 Nov 2012 15:38:24 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Millenbach <jmillenbach@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jirislaby@gmail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCHv3] tty: Added a CONFIG_TTY option to allow removal of TTY
Message-ID: <20121126233824.GA8868@kroah.com>
References: <1353033035-4928-1-git-send-email-jmillenbach@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353033035-4928-1-git-send-email-jmillenbach@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 06:30:35PM -0800, Joe Millenbach wrote:
> The option allows you to remove TTY and compile without errors. This
> saves space on systems that won't support TTY interfaces anyway.
> bloat-o-meter output is below.
> 
> The bulk of this patch consists of Kconfig changes adding "depends on
> TTY" to various serial devices and similar drivers that require the TTY
> layer.  Ideally, these dependencies would occur on a common intermediate
> symbol such as SERIO, but most drivers "select SERIO" rather than
> "depends on SERIO", and "select" does not respect dependencies.
> 
> bloat-o-meter output filtered to not show removed entries with awk
> '$3 != "-"' as the list was very long.
> 
> add/remove: 0/385 grow/shrink: 2/18 up/down: 14/-54016 (-54002)
> function                                     old     new   delta
> chr_dev_init                                 193     205     +12
> selinux_setprocattr                         1167    1169      +2
> static.__warned                              557     556      -1
> start_kernel                                 840     835      -5
> proc_root_init                               167     162      -5
> unregister_console                           165     157      -8
> sys_setsid                                   213     205      -8
> sys_vhangup                                   37      21     -16
> daemonize                                    689     673     -16
> t_stop                                        72      54     -18
> t_next                                       129     108     -21
> static.do_acct_process                       838     806     -32
> release_task                                1157    1125     -32
> do_exit                                     2325    2288     -37
> t_start                                      269     221     -48
> static.__func__                            18289   18219     -70
> do_task_stat                                2962    2892     -70
> flush_unauthorized_files                     740     614    -126
> static._rs                                  1440    1280    -160
> static.__key                                8560    8384    -176
> 
> Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

This is a nice idea, but I feel it's a bit too late in the 3.8 merge
window cycle for me to add this to linux-next at this point in time.

Can you rediff this once 3.8-rc1 is out and send it to me then?  That
way we can get a lot more testing in linux-next in order to make sure
it's ready for 3.9?

thanks,

greg k-h
