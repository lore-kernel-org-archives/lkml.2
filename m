Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1KAX5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:57:10 -0400
Received: from tundra.namei.org ([65.99.196.166]:40357 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878Ab1KAX5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:57:07 -0400
Date: Wed, 2 Nov 2011 10:57:06 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: clarify the purpose of LSMs
In-Reply-To: <20111101231314.GA25418@outflux.net>
Message-ID: <alpine.LRH.2.00.1111021055500.12545@tundra.namei.org>
References: <20111101231314.GA25418@outflux.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Nov 2011, Kees Cook wrote:

> Clarify the purpose of the LSM interface with some brief examples and
> pointers to additional documentation.

Please also point to the "Arjan protocol" for accepting LSMs.

http://kerneltrap.org/Linux/Documenting_Security_Module_Intent



> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  Documentation/security/00-INDEX        |    2 ++
>  Documentation/security/LSM.txt         |   26 ++++++++++++++++++++++++++
>  Documentation/security/credentials.txt |    6 +++---
>  3 files changed, 31 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/security/LSM.txt
> 
> diff --git a/Documentation/security/00-INDEX b/Documentation/security/00-INDEX
> index 1f33b73..eeed1de 100644
> --- a/Documentation/security/00-INDEX
> +++ b/Documentation/security/00-INDEX
> @@ -1,5 +1,7 @@
>  00-INDEX
>  	- this file.
> +LSM.txt
> +	- description of the Linux Security Module framework.
>  SELinux.txt
>  	- how to get started with the SELinux security enhancement.
>  Smack.txt
> diff --git a/Documentation/security/LSM.txt b/Documentation/security/LSM.txt
> new file mode 100644
> index 0000000..ec93803
> --- /dev/null
> +++ b/Documentation/security/LSM.txt
> @@ -0,0 +1,26 @@
> +Linux Security Module framework
> +-------------------------------
> +
> +The Linux Security Module (LSM) framework provides a mechanism for
> +various security checks to be hooked by new kernel extensions. The name
> +"module" is a bit of a misnomer since these extensions are not actually
> +loadable kernel modules. Instead, they are selectable at build-time via
> +CONFIG_DEFAULT_SECURITY and can be overridden at boot-time via the
> +"security=..." kernel command line argument, in the case where multiple
> +LSMs were built into a given kernel.
> +
> +The primary users of the LSM interface are Mandatory Access Control
> +(MAC) extensions which provide a comprehensive security policy. Examples
> +include SELinux, Smack, Tomoyo, and AppArmor. In addition to the larger
> +MAC extensions, other extensions can be built using the LSM to provide
> +specific changes to system operation when these tweaks are not available
> +in the core functionality of Linux itself.
> +
> +Without a specific LSM built into the kernel, the default LSM will be the
> +Linux capabilities system. Most LSMs choose to extend the capabilities
> +system, building their checks on top of the defined capability hooks.
> +For more details on capabilities, see capabilities(7) in the Linux
> +man-pages project.
> +
> +For extensive documentation on the available LSM hook interfaces, please
> +see include/linux/security.h.
> diff --git a/Documentation/security/credentials.txt b/Documentation/security/credentials.txt
> index fc0366c..8625705 100644
> --- a/Documentation/security/credentials.txt
> +++ b/Documentation/security/credentials.txt
> @@ -221,10 +221,10 @@ The Linux kernel supports the following types of credentials:
>   (5) LSM
>  
>       The Linux Security Module allows extra controls to be placed over the
> -     operations that a task may do.  Currently Linux supports two main
> -     alternate LSM options: SELinux and Smack.
> +     operations that a task may do.  Currently Linux supports several LSM
> +     options.
>  
> -     Both work by labelling the objects in a system and then applying sets of
> +     Some work by labelling the objects in a system and then applying sets of
>       rules (policies) that say what operations a task with one label may do to
>       an object with another label.
>  
> -- 
> 1.7.5.4
> 
> 
> -- 
> Kees Cook                                            @outflux.net
> 

-- 
James Morris
<jmorris@namei.org>
