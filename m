Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1HAWFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 18:05:49 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:56392 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753348Ab1HAWFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 18:05:44 -0400
Date: Mon, 1 Aug 2011 15:05:42 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Sergiu Iordache <sergiu@chromium.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        marco.stornelli@gmail.com
Subject: Re: [PATCH] char drivers: ramoops documentation
Message-Id: <20110801150542.7b15e55d.rdunlap@xenotime.net>
In-Reply-To: <1312234010-18004-1-git-send-email-sergiu@chromium.org>
References: <1312234010-18004-1-git-send-email-sergiu@chromium.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Aug 2011 14:26:50 -0700 Sergiu Iordache wrote:

> Add a documentation file describing the usage of Ramoops
> 
> Change-Id: I9dab9c4b9e4921b220574470372e330d32f9c63b

eh?

> Signed-off-by: Sergiu Iordache <sergiu@chromium.org>
> ---
>  Documentation/ramoops.txt |   67 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 67 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ramoops.txt
> 
> diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
> new file mode 100644
> index 0000000..ef606de
> --- /dev/null
> +++ b/Documentation/ramoops.txt
> @@ -0,0 +1,67 @@
> +Ramoops oops/panic logger
> +=========================
> +
> +Sergiu Iordache <sergiu@chromium.org>
> +
> +Updated: 1 August 2011
> +
> +0. Introduction
> +
> +Ramoops is an oops/panic logger in RAM. It works by logging oopses and panics

The logger lives in RAM or the log lives in RAM?

How about:

Ramoops is an oops/panic logger that writes its logs to RAM.

> +in a circular buffer. In order to work it needs a system with persistent RAM
> +so that the content of that area can survive after a restart.
> +
> +1. Ramoops concepts
> +
> +Ramoops uses a predefined memory area to store the dump. The start and size of
> +the memory area are set using two variables: "mem_address" for the start and
> +"mem_size" for the size. Memory size will be rounded to a multiple of two.

                                                rounded down to a power of two.

> +This memory area is divided into "record_size" chunks (also rounded to

                                                          also rounded down to
a power of two)

> +multiple of two) and each oops/panic writes a "record_size" chunk of
> +information. Dumping both oopses and panics can be done by setting 1 in the
> +"dump_oops" variable while setting 0 in that variable dumps only the panics.
> +
> +2. Setting the parameters
> +
> +Setting the ramoops parameters can be done in 2 different manners:
> + 1. Use the module parameters (which have the names of the variables described
> + as before).
> + 2. Use a platform device and set the platform data. The parameters can then
> + be set through that platform data. An example of doing that is:
> +
> +#include <linux/ramoops.h>
> +[...]
> +
> +static struct ramoops_platform_data ramoops_data = {
> +        .mem_size               = <...>,
> +        .mem_address            = <...>,
> +        .record_size            = <...>,
> +        .dump_oops              = <...>,
> +};
> +
> +static struct platform_device ramoops_dev = {
> +        .name = "ramoops",
> +        .dev = {
> +                .platform_data = &ramoops_data,
> +        },
> +};
> +
> +[... inside a function ...]
> +int ret;
> +
> +ret = platform_device_register(&ramoops_dev);
> +if (ret) {
> +	printk(KERN_ERR "unable to register platform device\n");
> +	return ret;
> +}
> +
> +3. Dump format
> +
> +The data dump begins with a header, currently defined at "====" followed by a

                                                         as "=====",

> +timestamp and then continues with the actual dump data.
> +
> +4. Reading the data
> +
> +The dump data can be read from memory (through /dev/mem or other means).
> +Getting the module parameters, which are needed in order to parse the data can

                                                               parse the data, can

> +be done through /sys/module/ramoops/parameters/* .
> -- 



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
