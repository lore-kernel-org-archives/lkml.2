Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab2HAOn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:43:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56405 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab2HAOn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:43:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vinayak Holikatti <vinholikatti@gmail.com>
Subject: Re: [PATCH V3 2/4] [SCSI] drivers/scsi/ufs: Separate PCI code into glue driver
Date: Wed, 1 Aug 2012 14:43:20 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, arnd@linaro.org,
        girish.shivananjappa@linaro.org, saugata.das@linaro.org,
        vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com,
        dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com,
        sreekumar.c@samsung.com, Santosh Yaraganavi <santoshsy@gmail.com>
References: <1343292170-2599-1-git-send-email-vinholikatti@gmail.com> <1343292170-2599-3-git-send-email-vinholikatti@gmail.com>
In-Reply-To: <1343292170-2599-3-git-send-email-vinholikatti@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208011443.20761.arnd@arndb.de>
X-Provags-ID: V02:K0:YUHqgYYiyzsNm/WR/zmI9mQQhwhMcW0J1sf6LekPZ3q
 fLd2ypOJOsdzZbudWy/CZiw80Hk5LcBF8qLZQU1Ym0yw+GzIKm
 NvqWhvHQh3P1y5dYmv+jCETXSuIx2pyhikMRbSuzxyqcYVYOjm
 gCzP69RhOiuy2RDLdt7jU+DDUSZWojiwBFVXa4SKiu/EjQYvm8
 4WiVe19dr2q3SHbi5lDz92dGhjnnsag9rDpj3lC8UC5kJT1v11
 2KXHIu+LK4pTj4IoqZBWtfoWC5wT9QAzF7o1jzK5ssLLxaKlHR
 0px6mxpymo1PYb1n3qKpAewyhVctMhL3CSPdY9juu7Nc08G++i
 gKvzOsy8Mrzlwcm5fao8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 July 2012, Vinayak Holikatti wrote:

> diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
> new file mode 100644
> index 0000000..d078744
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufshcd-pci.c
> @@ -0,0 +1,228 @@
> +/*
> + * Universal Flash Storage Host controller driver
> + *
> + * This code is based on drivers/scsi/ufs/ufshcd-pci.c
> + * Copyright (C) 2011-2012 Samsung India Software Operations
> + *
> + * Santosh Yaraganavi <santosh.sy@samsung.com>
> + * Vinayak Holikatti <h.vinayak@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * NO WARRANTY
> + * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
> + * CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
> + * LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
> + * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
> + * solely responsible for determining the appropriateness of using and
> + * distributing the Program and assumes all risks associated with its
> + * exercise of rights under this Agreement, including but not limited to
> + * the risks and costs of program errors, damage to or loss of data,
> + * programs or equipment, and unavailability or interruption of operations.
> +
> + * DISCLAIMER OF LIABILITY
> + * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
> + * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
> + * DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
> + * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
> + * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
> + * USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
> + * HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES

It's a bit unusual to have three separate warranty disclaimers. Unless you've
specifically been asked to include all of them by your legal department to
do it like this, I would suggest you remove all but on of them.

> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
> + * USA.

These statements also get outdated frequently when the FSF moves its
offices. We have the same thing in the global COPYING file of the kernel,
so most people don't carry their own copy.

> +static int __init ufshcd_module_init(void)
>  {
> +	pr_info("UFS Host Driver Core loaded\n");
>  	return 0;
>  }
>  
> +static void __exit ufshcd_module_exit(void)
> +{
> +	pr_info("UFS Host Driver Core unloaded\n");
> +}
> +
> +module_init(ufshcd_module_init);
> +module_exit(ufshcd_module_exit);

The pr_info statements do not add any real value here. I would just drop
the module_init/module_exit functions entirely as they are not required.

	Arnd
