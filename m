Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab2IPQxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 12:53:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56817 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2IPQxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 12:53:40 -0400
Date: Mon, 17 Sep 2012 00:53:31 +0800
From: Tekkaman Ninja <tekkamanninja@gmail.com>
To: Dong Aisheng <b29396@freescale.com>, Harry Wei <harryxiyou@gmail.com>
Cc: Greg-Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, kernel@vger.linux-kernel.cn,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH]Documentation:Fixes some translation error in
 Documentation/zh_CN/gpio.txt
Message-ID: <20120916165331.GA7285@Super-MAGI>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes some translation error in Documentation/zh_CN/gpio.txt
The modification is based on Dong Aisheng <b29396@freescale.com>'s
corrections:
    1.Two "OUTPUT" is incorrectly translated as "输入";
    2.five improvement of translation;
    3.Delete a redundant paragraph,

Signed-off-by: Fu Wei <tekkamanninja@gmail.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
Acked-by: Dong Aisheng <b29396@freescale.com>

---
 Documentation/zh_CN/gpio.txt |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/Documentation/zh_CN/gpio.txt b/Documentation/zh_CN/gpio.txt
index 0484387..4fa7b4e 100644
--- a/Documentation/zh_CN/gpio.txt
+++ b/Documentation/zh_CN/gpio.txt
@@ -129,10 +129,10 @@ FPGA 的特定板子上使用 80-95。编号不一定要连续,那些平台中
 使用 GPIO
 ---------
 对于一个 GPIO，系统应该做的第一件事情就是通过 gpio_request()
-函数分配他，见下文。
+函数分配它，见下文。
 
-而接下来要做的是标识它的方向，这通常是在板级启动代码中为 GPIO 设置
-一个 platform_device 时做的。
+接下来是设置I/O方向，这通常是在板级启动代码中为所使用的 GPIO 设置
+platform_device 时完成。
 
 	/* 设置为输入或输出, 返回 0 或负的错误代码 */
 	int gpio_direction_input(unsigned gpio);
@@ -167,17 +167,18 @@ get/set(获取/设置)函数调用没法返回错误,且有可能是配置错误
 	/* GPIO 输入:返回零或非零 */
 	int gpio_get_value(unsigned gpio);
 
-	/* GPIO 输入 */
+	/* GPIO 输出 */
 	void gpio_set_value(unsigned gpio, int value);
 
-返回值是布尔值，零表示低电平，非零表示高电平。当读取一个输出引脚的值时，
+GPIO值是布尔值，零表示低电平，非零表示高电平。当读取一个输出引脚的值时，
 返回值应该是引脚上的值。这个值不总是和输出值相符，因为存在开漏输出信号和
-输出潜伏期的问题。
+输出延迟问题。
 
-以上的 get/set 函数不会对早期已经通过 gpio_direction_*()报告“无效的
-GPIO”返回错误。此外,还需要注意的是并不是所有平台都可以从输出引脚中读取
-数据的，那些引脚也不总是返回零。且对那些无法安全访问(可能会休眠)的 GPIO
-(见下文)使用这些函数是错误的。
+以上的 get/set 函数无错误返回值，因为之前 gpio_direction_*()应已检查过
+其是否为“无效GPIO”。此外，还需要注意的是并不是所有平台都可以从输出引脚
+中读取数据，对于不能读取的引脚应总返回零。另外，对那些在原子上下文中无法
+安全访问的 GPIO (译者注：因为访问可能导致休眠)使用这些函数是不合适的
+(见下文)。
 
 在 GPIO 编号(还有输出、值)为常数的情况下,鼓励通过平台特定的实现来优化
 这两个函数来访问 GPIO 值。这种情况(读写一个硬件寄存器)下只需要几条指令
@@ -202,7 +203,7 @@ GPIO 值的命令需要等待其信息排到队首才发送命令，再获得其
 	/* GPIO 输入:返回零或非零 ,可能会休眠 */
 	int gpio_get_value_cansleep(unsigned gpio);
 
-	/* GPIO 输入,可能会休眠 */
+	/* GPIO 输出,可能会休眠 */
 	void gpio_set_value_cansleep(unsigned gpio, int value);
 
 
@@ -247,7 +248,7 @@ GPIO 值的命令需要等待其信息排到队首才发送命令，再获得其
 进入进程之前是可以申请的。
 
 这个函数完成两个基本的目标。一是标识那些实际上已作为 GPIO 使用的信号线，
-这样便于更好地诊断;系统可能需要服务几百个潜在的 GPIO，但是对于任何一个
+这样便于更好地诊断;系统可能需要服务几百个可用的 GPIO，但是对于任何一个
 给定的电路板通常只有一些被使用。另一个目的是捕获冲突，查明错误:如两个或
 更多驱动错误地认为他们已经独占了某个信号线,或是错误地认为移除一个管理着
 某个已激活信号的驱动是安全的。也就是说，申请 GPIO 的作用类似一种锁机制。
@@ -381,11 +382,6 @@ irq_to_gpio()返回的非错误值大多数通常可以被 gpio_get_value()所
 比如在 IRQ 是沿触发时初始化或更新驱动状态。注意某些平台不支持反映射,所以
 你应该尽量避免使用它。
 
-它们的返回值为对应命名空间的相关编号，或是负的错误代码(如果无法映射)。
-(例如,某些 GPIO 无法做为 IRQ 使用。)以下的编号错误是未经检测的：
-使用一个未通过 gpio_direction_input()配置为输入的 GPIO 编号，
-或者使用一个并非来源于gpio_to_irq()的 IRQ 编号。
-
 
 模拟开漏信号
 ----------------------------
@@ -500,7 +496,7 @@ ARCH_WANT_OPTIONAL_GPIOLIB 意味着 gpiolib 核心默认关闭,且用户可以
   #define gpio_cansleep		__gpio_cansleep
 
 这些定义可以用更理想的实现方法替代，那就是使用经过逻辑优化的内联函数来访问
-基于特定片上系统的 GPIO。例如,若引用 GPIO 的(寄存器地址)是常量“12”，
+基于特定片上系统的 GPIO。例如,若引用的 GPIO (寄存器位偏移)是常量“12”，
 读取或设置它可能只需少则两或三个指令，且不会休眠。当这样的优化无法实现时，
 那些函数必须使用框架提供的代码，那就至少要几十条指令才可以实现。对于用 GPIO
 模拟的 I/O 接口, 如此精简指令是很有意义的。
-- 
1.7.9.5

