Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab2IEMXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 08:23:12 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:52027
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337Ab2IEMXJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 08:23:09 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dIc89bh1432Izz1202h1082kzz8275bh8275dhz2dh2a8h668h839h93fhd25hf0ah107ah1155h)
Date: Wed, 5 Sep 2012 20:00:38 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Ninja Tekkaman <tekkamanninja@gmail.com>
CC: Harry Wei <harryxiyou@gmail.com>,
        Greg-Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        <kernel@vger.linux-kernel.cn>
Subject: Re: [PATCH] Chinese translation of Documentation/gpio.txt
Message-ID: <20120905120036.GA4242@shlinux2.ap.freescale.net>
References: <CA+HMz3hLcxbOZ19-yposJd3pQxJXAL_FkrCPmK8pYnj0hJeuAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CA+HMz3hLcxbOZ19-yposJd3pQxJXAL_FkrCPmK8pYnj0hJeuAw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Tue, Aug 28, 2012 at 10:03:13PM +0800, Ninja Tekkaman wrote:
> This is a Chinese translated version of Documentation/gpio.txt
> 
> Signed-off-by: Fu Wei <tekkamanninja@gmail.com>
> ---
>  Documentation/zh_CN/gpio.txt |  662 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 662 insertions(+)
>  create mode 100644 Documentation/zh_CN/gpio.txt
> 
The doc mostly looks good.
A few minor comments.

> +而接下来要做的是标识它的方向，这通常是在板级启动代码中为 GPIO 设置
> +一个 platform_device 时做的。
How about as follows?
这通常是在板级启动代码中配置platform_device时为使用的GPIO设置方向。

> +	/* GPIO 输入:返回零或非零 */
> +	int gpio_get_value(unsigned gpio);
> +
> +	/* GPIO 输入 */
输出

> +	void gpio_set_value(unsigned gpio, int value);
> +
> +返回值是布尔值，零表示低电平，非零表示高电平。当读取一个输出引脚的值时，
GPIO值是布尔型

> +返回值应该是引脚上的值。这个值不总是和输出值相符，因为存在开漏输出信号和
> +输出潜伏期的问题。
输出延迟的问题

> +
> +以上的 get/set 函数不会对早期已经通过 gpio_direction_*()报告“无效的
> +GPIO”返回错误。此外,还需要注意的是并不是所有平台都可以从输出引脚中读取
> +数据的，那些引脚也不总是返回零。且对那些无法安全访问(可能会休眠)的 GPIO
> +(见下文)使用这些函数是错误的。
以上的 get/set 函数没有错误返回值，因为之前gpio_direction_*()已经检查过
是否是“无效的GPIO”。此外,还需要注意的是并不是所有平台都可以从输出引脚
中读取数据的，对于不能读的应该总是返回零。另外,对那些在不睡眠(见下文）
的情况下不能安全访问的GPIO使用这些函数是错误的。

> +为了访问这种 GPIO,内核定义了一套不同的函数:
> +
> +	/* GPIO 输入:返回零或非零 ,可能会休眠 */
> +	int gpio_get_value_cansleep(unsigned gpio);
> +
> +	/* GPIO 输入,可能会休眠 */
输出

> +这个函数完成两个基本的目标。一是标识那些实际上已作为 GPIO 使用的信号线，
> +这样便于更好地诊断;系统可能需要服务几百个潜在的 GPIO，但是对于任何一个
系统可能有几百个可用的GPIO

> +它们的返回值为对应命名空间的相关编号，或是负的错误代码(如果无法映射)。
> +(例如,某些 GPIO 无法做为 IRQ 使用。)以下的编号错误是未经检测的:使用一个
> +未通过 gpio_direction_input()配置为输入的 GPIO 编号，或者使用一个
> +并非来源于gpio_to_irq()的 IRQ 编号。
...
> +
> +这两个映射函数可能会在信号编号的加减计算过程上花些时间。它们不可休眠。
> +
> +gpio_to_irq()返回的非错误值可以传递给 request_irq()或者 free_irq()。
> +它们通常通过板级特定的初始化代码存放到平台设备的 IRQ 资源中。注意:IRQ
> +触发选项是 IRQ 接口的一部分，如 IRQF_TRIGGER_FALLING，系统唤醒能力
> +也是如此。
> +
> +irq_to_gpio()返回的非错误值大多数通常可以被 gpio_get_value()所使用，
> +比如在 IRQ 是沿触发时初始化或更新驱动状态。注意某些平台不支持反映射,所以
> +你应该尽量避免使用它。
> +
> +它们的返回值为对应命名空间的相关编号，或是负的错误代码(如果无法映射)。
> +(例如,某些 GPIO 无法做为 IRQ 使用。)以下的编号错误是未经检测的：
> +使用一个未通过 gpio_direction_input()配置为输入的 GPIO 编号，
> +或者使用一个并非来源于gpio_to_irq()的 IRQ 编号。
It looks these 4 lines are duplicated and should be removed.

> +这些定义可以用更理想的实现方法替代，那就是使用经过逻辑优化的内联函数来访问
> +基于特定片上系统的 GPIO。例如,若引用 GPIO 的(寄存器地址)是常量“12”，
例如,若引用的GPIO 是常量“12”

BTW, i meet a few whitespace warnings when applying your patch and
the Chinese in Documentation/zh_CN/gpio.txt can not be read by my
VIM, i tried many character set config such as UTF-8 and VSCII,
but still mess code. But the Windows Notepad can read it.
I don't know the reason, probably you could check it.

Otherwise you can add my ack.
Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng

