Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab0DMUCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:02:32 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:17372 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0DMUCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:02:31 -0400
Date: Tue, 13 Apr 2010 13:00:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Aristeu Rozanski <aris@redhat.com>, linux-kbuild@vger.kernel.org,
       Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com, kyle@redhat.com,
       vgoyal@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH] kconfig: introduce nonint_oldconfig and
 loose_nonint_oldconfig
Message-Id: <20100413130031.d4dec19b.randy.dunlap@oracle.com>
In-Reply-To: <20100413194747.GX31193@redhat.com>
References: <20100413194747.GX31193@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BC4CDC4.0112:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Apr 2010 15:47:48 -0400 Aristeu Rozanski wrote:

> This patch has been around for a long time in Fedora and Red Hat Enterprise
> Linux kernels and it may be useful for others. The nonint_oldconfig target
> will fail and print the unset config options while loose_nonint_oldconfig will
> simply let the config option unset. They're useful in distro kernel packages
> where the config files are built using a combination of smaller config files.
> The patch's author AFAIK is Arjan van de Ven. Arjan, please add a Signed-off-by
> if you're the original author.

Roland McGrath added the loose parts according to his email of 2008.Mar.05:
"I added this one (loose_nonint_oldconfig target, -B option to conf)."

after Dave Jones posted this patch.

(adding linux-kbuild mailing list & kbuild maintainer)

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>



> Signed-off-by: Aristeu Rozanski <aris@redhat.com> 


> @@ -613,5 +641,5 @@ int main(int ac, char **av)
>  			exit(1);
>  		}
>  	}
> -	return 0;
> +	return return_value;
>  }

Having 'make oldconfig' exit with Exit status: 139  (for example)
can be confusing.  I know that from experience.  It took me a bit
to find out what that meant.  That part could be improved...

---
~Randy
