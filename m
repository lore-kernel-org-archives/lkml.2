Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab1GRRtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 13:49:20 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:38452 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751024Ab1GRRtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 13:49:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=IXDnp4K4Y+p8pQD8RrfXjVGiQAUBeL4ej6it67kZYJgKPsM5Q0lh3zNc3VOZgZ3VT5ED++cCIh1dZfvS9bG1k00zDiYJ3q5X+9l3VXjMT2xqiNBppI/pa06NNnW0vTHE;
Date: Mon, 18 Jul 2011 10:49:16 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Borislav Petkov <bp@alien8.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: Refresh sysctl/kernel.txt
Message-Id: <20110718104916.fbf00e3d.rdunlap@xenotime.net>
In-Reply-To: <1310804601-27645-1-git-send-email-bp@alien8.de>
References: <1310804601-27645-1-git-send-email-bp@alien8.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jul 2011 10:23:21 +0200 Borislav Petkov wrote:

> More specifically,
> 
> - drop stale index entries
> - sync and sort index and entries
> - reflow sticking out paragraphs to colwidth 72
> - correct typos
> - cleanup whitespace
> 
> Signed-off-by: Borislav Petkov <bp@alien8.de>

Applied, thanks.

> ---
>  Documentation/sysctl/kernel.txt |  215 ++++++++++++++++++++-------------------
>  1 files changed, 110 insertions(+), 105 deletions(-)
> 
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 5e7cb39..1c7fb0a 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -17,23 +17,21 @@ before actually making adjustments.
>  
>  Currently, these files might (depending on your configuration)
>  show up in /proc/sys/kernel:
> -- acpi_video_flags
> +
>  - acct
> +- acpi_video_flags
> +- auto_msgmni
>  - bootloader_type	     [ X86 only ]
>  - bootloader_version	     [ X86 only ]
>  - callhome		     [ S390 only ]
> -- auto_msgmni
>  - core_pattern
>  - core_pipe_limit
>  - core_uses_pid
>  - ctrl-alt-del
> -- dentry-state
>  - dmesg_restrict
>  - domainname
>  - hostname
>  - hotplug
> -- java-appletviewer           [ binfmt_java, obsolete ]
> -- java-interpreter            [ binfmt_java, obsolete ]
>  - kptr_restrict
>  - kstack_depth_to_print       [ X86 only ]
>  - l2cr                        [ PPC only ]
> @@ -48,10 +46,14 @@ show up in /proc/sys/kernel:
>  - overflowgid
>  - overflowuid
>  - panic
> +- panic_on_oops
> +- panic_on_unrecovered_nmi
>  - pid_max
>  - powersave-nap               [ PPC only ]
> -- panic_on_unrecovered_nmi
>  - printk
> +- printk_delay
> +- printk_ratelimit
> +- printk_ratelimit_burst
>  - randomize_va_space
>  - real-root-dev               ==> Documentation/initrd.txt
>  - reboot-cmd                  [ SPARC only ]
> @@ -62,6 +64,7 @@ show up in /proc/sys/kernel:
>  - shmall
>  - shmmax                      [ sysv ipc ]
>  - shmmni
> +- softlockup_thresh
>  - stop-a                      [ SPARC only ]
>  - sysrq                       ==> Documentation/sysrq.txt
>  - tainted
> @@ -71,15 +74,6 @@ show up in /proc/sys/kernel:
>  
>  ==============================================================
>  
> -acpi_video_flags:
> -
> -flags
> -
> -See Doc*/kernel/power/video.txt, it allows mode of video boot to be
> -set during run time.
> -
> -==============================================================
> -
>  acct:
>  
>  highwater lowwater frequency
> @@ -97,6 +91,25 @@ valid for 30 seconds.
>  
>  ==============================================================
>  
> +acpi_video_flags:
> +
> +flags
> +
> +See Doc*/kernel/power/video.txt, it allows mode of video boot to be
> +set during run time.
> +
> +==============================================================
> +
> +auto_msgmni:
> +
> +Enables/Disables automatic recomputing of msgmni upon memory add/remove
> +or upon ipc namespace creation/removal (see the msgmni description
> +above). Echoing "1" into this file enables msgmni automatic recomputing.
> +Echoing "0" turns it off. auto_msgmni default value is 1.
> +
> +
> +==============================================================
> +
>  bootloader_type:
>  
>  x86 bootloader identification
> @@ -172,22 +185,24 @@ core_pattern is used to specify a core dumpfile pattern name.
>  
>  core_pipe_limit:
>  
> -This sysctl is only applicable when core_pattern is configured to pipe core
> -files to a user space helper (when the first character of core_pattern is a '|',
> -see above).  When collecting cores via a pipe to an application, it is
> -occasionally useful for the collecting application to gather data about the
> -crashing process from its /proc/pid directory.  In order to do this safely, the
> -kernel must wait for the collecting process to exit, so as not to remove the
> -crashing processes proc files prematurely.  This in turn creates the possibility
> -that a misbehaving userspace collecting process can block the reaping of a
> -crashed process simply by never exiting.  This sysctl defends against that.  It
> -defines how many concurrent crashing processes may be piped to user space
> -applications in parallel.  If this value is exceeded, then those crashing
> -processes above that value are noted via the kernel log and their cores are
> -skipped.  0 is a special value, indicating that unlimited processes may be
> -captured in parallel, but that no waiting will take place (i.e. the collecting
> -process is not guaranteed access to /proc/<crashing pid>/).  This value defaults
> -to 0.
> +This sysctl is only applicable when core_pattern is configured to pipe
> +core files to a user space helper (when the first character of
> +core_pattern is a '|', see above).  When collecting cores via a pipe
> +to an application, it is occasionally useful for the collecting
> +application to gather data about the crashing process from its
> +/proc/pid directory.  In order to do this safely, the kernel must wait
> +for the collecting process to exit, so as not to remove the crashing
> +processes proc files prematurely.  This in turn creates the
> +possibility that a misbehaving userspace collecting process can block
> +the reaping of a crashed process simply by never exiting.  This sysctl
> +defends against that.  It defines how many concurrent crashing
> +processes may be piped to user space applications in parallel.  If
> +this value is exceeded, then those crashing processes above that value
> +are noted via the kernel log and their cores are skipped.  0 is a
> +special value, indicating that unlimited processes may be captured in
> +parallel, but that no waiting will take place (i.e. the collecting
> +process is not guaranteed access to /proc/<crashing pid>/).  This
> +value defaults to 0.
>  
>  ==============================================================
>  
> @@ -218,14 +233,14 @@ to decide what to do with it.
>  
>  dmesg_restrict:
>  
> -This toggle indicates whether unprivileged users are prevented from using
> -dmesg(8) to view messages from the kernel's log buffer.  When
> -dmesg_restrict is set to (0) there are no restrictions.  When
> +This toggle indicates whether unprivileged users are prevented
> +from using dmesg(8) to view messages from the kernel's log buffer.
> +When dmesg_restrict is set to (0) there are no restrictions. When
>  dmesg_restrict is set set to (1), users must have CAP_SYSLOG to use
>  dmesg(8).
>  
> -The kernel config option CONFIG_SECURITY_DMESG_RESTRICT sets the default
> -value of dmesg_restrict.
> +The kernel config option CONFIG_SECURITY_DMESG_RESTRICT sets the
> +default value of dmesg_restrict.
>  
>  ==============================================================
>  
> @@ -256,13 +271,6 @@ Default value is "/sbin/hotplug".
>  
>  ==============================================================
>  
> -l2cr: (PPC only)
> -
> -This flag controls the L2 cache of G3 processor boards. If
> -0, the cache is disabled. Enabled if nonzero.
> -
> -==============================================================
> -
>  kptr_restrict:
>  
>  This toggle indicates whether restrictions are placed on
> @@ -283,6 +291,13 @@ kernel stack.
>  
>  ==============================================================
>  
> +l2cr: (PPC only)
> +
> +This flag controls the L2 cache of G3 processor boards. If
> +0, the cache is disabled. Enabled if nonzero.
> +
> +==============================================================
> +
>  modules_disabled:
>  
>  A toggle value indicating if modules are allowed to be loaded
> @@ -293,6 +308,21 @@ to false.
>  
>  ==============================================================
>  
> +nmi_watchdog:
> +
> +Enables/Disables the NMI watchdog on x86 systems. When the value is
> +non-zero the NMI watchdog is enabled and will continuously test all
> +online cpus to determine whether or not they are still functioning
> +properly. Currently, passing "nmi_watchdog=" parameter at boot time is
> +required for this function to work.
> +
> +If LAPIC NMI watchdog method is in use (nmi_watchdog=2 kernel
> +parameter), the NMI watchdog shares registers with oprofile. By
> +disabling the NMI watchdog, oprofile may have more registers to
> +utilize.
> +
> +==============================================================
> +
>  osrelease, ostype & version:
>  
>  # cat osrelease
> @@ -312,10 +342,10 @@ The only way to tune these values is to rebuild the kernel :-)
>  
>  overflowgid & overflowuid:
>  
> -if your architecture did not always support 32-bit UIDs (i.e. arm, i386,
> -m68k, sh, and sparc32), a fixed UID and GID will be returned to
> -applications that use the old 16-bit UID/GID system calls, if the actual
> -UID or GID would exceed 65535.
> +if your architecture did not always support 32-bit UIDs (i.e. arm,
> +i386, m68k, sh, and sparc32), a fixed UID and GID will be returned to
> +applications that use the old 16-bit UID/GID system calls, if the
> +actual UID or GID would exceed 65535.
>  
>  These sysctls allow you to change the value of the fixed UID and GID.
>  The default is 65534.
> @@ -324,9 +354,22 @@ The default is 65534.
>  
>  panic:
>  
> -The value in this file represents the number of seconds the
> -kernel waits before rebooting on a panic. When you use the
> -software watchdog, the recommended setting is 60.
> +The value in this file represents the number of seconds the kernel
> +waits before rebooting on a panic. When you use the software watchdog,
> +the recommended setting is 60.
> +
> +==============================================================
> +
> +panic_on_unrecovered_nmi:
> +
> +The default Linux behaviour on an NMI of either memory or unknown is
> +to continue operation. For many environments such as scientific
> +computing it is preferable that the box is taken out and the error
> +dealt with than an uncorrected parity/ECC error get propagated.
> +
> +A small number of systems do generate NMI's for bizarre random reasons
> +such as power management so the default is off. That sysctl works like
> +the existing panic controls already in that directory.
>  
>  ==============================================================
>  
> @@ -376,6 +419,14 @@ the different loglevels.
>  
>  ==============================================================
>  
> +printk_delay:
> +
> +Delay each printk message in printk_delay milliseconds
> +
> +Value from 0 - 10000 is allowed.
> +
> +==============================================================
> +
>  printk_ratelimit:
>  
>  Some warning messages are rate limited. printk_ratelimit specifies
> @@ -395,15 +446,7 @@ send before ratelimiting kicks in.
>  
>  ==============================================================
>  
> -printk_delay:
> -
> -Delay each printk message in printk_delay milliseconds
> -
> -Value from 0 - 10000 is allowed.
> -
> -==============================================================
> -
> -randomize-va-space:
> +randomize_va_space:
>  
>  This option can be used to select the type of process address
>  space randomization that is used in the system, for architectures
> @@ -466,11 +509,11 @@ are doing anyway :)
>  
>  ==============================================================
>  
> -shmmax: 
> +shmmax:
>  
>  This value can be used to query and set the run time limit
>  on the maximum shared memory segment size that can be created.
> -Shared memory segments up to 1Gb are now supported in the 
> +Shared memory segments up to 1Gb are now supported in the
>  kernel.  This value defaults to SHMMAX.
>  
>  ==============================================================
> @@ -484,7 +527,7 @@ tunable to zero will disable the softlockup detection altogether.
>  
>  ==============================================================
>  
> -tainted: 
> +tainted:
>  
>  Non-zero if the kernel has been tainted.  Numeric values, which
>  can be ORed together:
> @@ -509,49 +552,11 @@ can be ORed together:
>  
>  ==============================================================
>  
> -auto_msgmni:
> -
> -Enables/Disables automatic recomputing of msgmni upon memory add/remove or
> -upon ipc namespace creation/removal (see the msgmni description above).
> -Echoing "1" into this file enables msgmni automatic recomputing.
> -Echoing "0" turns it off.
> -auto_msgmni default value is 1.
> -
> -==============================================================
> -
> -nmi_watchdog:
> -
> -Enables/Disables the NMI watchdog on x86 systems.  When the value is non-zero
> -the NMI watchdog is enabled and will continuously test all online cpus to
> -determine whether or not they are still functioning properly. Currently,
> -passing "nmi_watchdog=" parameter at boot time is required for this function
> -to work.
> -
> -If LAPIC NMI watchdog method is in use (nmi_watchdog=2 kernel parameter), the
> -NMI watchdog shares registers with oprofile. By disabling the NMI watchdog,
> -oprofile may have more registers to utilize.
> -
> -==============================================================
> -
>  unknown_nmi_panic:
>  
> -The value in this file affects behavior of handling NMI. When the value is
> -non-zero, unknown NMI is trapped and then panic occurs. At that time, kernel
> -debugging information is displayed on console.
> -
> -NMI switch that most IA32 servers have fires unknown NMI up, for example.
> -If a system hangs up, try pressing the NMI switch.
> -
> -==============================================================
> -
> -panic_on_unrecovered_nmi:
> -
> -The default Linux behaviour on an NMI of either memory or unknown is to continue
> -operation. For many environments such as scientific computing it is preferable
> -that the box is taken out and the error dealt with than an uncorrected
> -parity/ECC error get propogated.
> -
> -A small number of systems do generate NMI's for bizarre random reasons such as
> -power management so the default is off. That sysctl works like the existing
> -panic controls already in that directory.
> +The value in this file affects behavior of handling NMI. When the
> +value is non-zero, unknown NMI is trapped and then panic occurs. At
> +that time, kernel debugging information is displayed on console.
>  
> +NMI switch that most IA32 servers have fires unknown NMI up, for
> +example.  If a system hangs up, try pressing the NMI switch.
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
