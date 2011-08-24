Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab1HXKdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 06:33:44 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:44027 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751412Ab1HXKdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 06:33:41 -0400
Subject: Re: [PATCH 06/14] [media] cx18: Use current logging styles
From: Andy Walls <awalls@md.metrocast.net>
To: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 24 Aug 2011 06:34:07 -0400
In-Reply-To: <29abc343c4fce5d019ce56f5a3882aedaeb092bc.1313966089.git.joe@perches.com>
References: <cover.1313966088.git.joe@perches.com>
	 <29abc343c4fce5d019ce56f5a3882aedaeb092bc.1313966089.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1314182047.2253.3.camel@palomino.walls.org>
Mime-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.4.6813,1.0.211,0.0.0000
 definitions=2011-08-23_10:2011-08-23,2011-08-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1108230308
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-08-21 at 15:56 -0700, Joe Perches wrote:
> Add pr_fmt.
> Convert printks to pr_<level>.
> Convert printks without KERN_<level> to appropriate pr_<level>.
> Removed embedded prefixes when pr_fmt was added.
> Use ##__VA_ARGS__ for variadic macros.
> Coalesce format strings.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Hi Joe:

1. It is important to preserve the per-card prefixes emitted by the
driver: cx18-0, cx18-1, cx18-2, etc.  With a quick skim, I think your
change preserves the format of all output messages (except removing
periods).  Can you confirm this?

2. PLease don't add a pr_fmt() #define to exevry file.  Just put one
where all the other CX18_*() macros are defined.  Every file picks those
up.


Thanks,
Andy


> ---
>  drivers/media/video/cx18/cx18-alsa-main.c   |   26 ++--
>  drivers/media/video/cx18/cx18-alsa-mixer.c  |    2 +
>  drivers/media/video/cx18/cx18-alsa-pcm.c    |   12 +-
>  drivers/media/video/cx18/cx18-alsa.h        |   32 +++---
>  drivers/media/video/cx18/cx18-audio.c       |    2 +
>  drivers/media/video/cx18/cx18-av-audio.c    |    2 +
>  drivers/media/video/cx18/cx18-av-core.c     |    2 +
>  drivers/media/video/cx18/cx18-av-firmware.c |    2 +
>  drivers/media/video/cx18/cx18-av-vbi.c      |    1 +
>  drivers/media/video/cx18/cx18-controls.c    |    3 +
>  drivers/media/video/cx18/cx18-driver.c      |   35 +++---
>  drivers/media/video/cx18/cx18-driver.h      |  177 +++++++++++++++------------
>  drivers/media/video/cx18/cx18-dvb.c         |    2 +
>  drivers/media/video/cx18/cx18-fileops.c     |    9 +-
>  drivers/media/video/cx18/cx18-firmware.c    |    4 +-
>  drivers/media/video/cx18/cx18-gpio.c        |    2 +
>  drivers/media/video/cx18/cx18-i2c.c         |    2 +
>  drivers/media/video/cx18/cx18-io.c          |    2 +
>  drivers/media/video/cx18/cx18-ioctl.c       |    4 +-
>  drivers/media/video/cx18/cx18-irq.c         |    2 +
>  drivers/media/video/cx18/cx18-mailbox.c     |    2 +
>  drivers/media/video/cx18/cx18-queue.c       |    2 +
>  drivers/media/video/cx18/cx18-scb.c         |    2 +
>  drivers/media/video/cx18/cx18-streams.c     |    2 +
>  drivers/media/video/cx18/cx18-vbi.c         |    2 +
>  drivers/media/video/cx18/cx18-video.c       |    2 +
>  26 files changed, 201 insertions(+), 134 deletions(-)
> 
> diff --git a/drivers/media/video/cx18/cx18-alsa-main.c b/drivers/media/video/cx18/cx18-alsa-main.c
> index a1e6c2a..99d1b01 100644
> --- a/drivers/media/video/cx18/cx18-alsa-main.c
> +++ b/drivers/media/video/cx18/cx18-alsa-main.c
> @@ -22,6 +22,8 @@
>   *  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/init.h>
>  #include <linux/slab.h>
>  #include <linux/module.h>
> @@ -42,11 +44,11 @@
>  
>  int cx18_alsa_debug;
>  
> -#define CX18_DEBUG_ALSA_INFO(fmt, arg...) \
> -	do { \
> -		if (cx18_alsa_debug & 2) \
> -			printk(KERN_INFO "%s: " fmt, "cx18-alsa", ## arg); \
> -	} while (0);
> +#define CX18_DEBUG_ALSA_INFO(fmt, ...)				  \
> +do {								  \
> +	if (cx18_alsa_debug & 2)				  \
> +		pr_info(fmt, ##__VA_ARGS__);			  \
> +} while (0)
>  
>  module_param_named(debug, cx18_alsa_debug, int, 0644);
>  MODULE_PARM_DESC(debug,
> @@ -203,14 +205,13 @@ int cx18_alsa_load(struct cx18 *cx)
>  	struct cx18_stream *s;
>  
>  	if (v4l2_dev == NULL) {
> -		printk(KERN_ERR "cx18-alsa: %s: struct v4l2_device * is NULL\n",
> -		       __func__);
> +		pr_err("%s: struct v4l2_device * is NULL\n", __func__);
>  		return 0;
>  	}
>  
>  	cx = to_cx18(v4l2_dev);
>  	if (cx == NULL) {
> -		printk(KERN_ERR "cx18-alsa cx is NULL\n");
> +		pr_err("cx is NULL\n");
>  		return 0;
>  	}
>  
> @@ -239,7 +240,7 @@ int cx18_alsa_load(struct cx18 *cx)
>  
>  static int __init cx18_alsa_init(void)
>  {
> -	printk(KERN_INFO "cx18-alsa: module loading...\n");
> +	pr_info("module loading...\n");
>  	cx18_ext_init = &cx18_alsa_load;
>  	return 0;
>  }
> @@ -260,8 +261,7 @@ static int __exit cx18_alsa_exit_callback(struct device *dev, void *data)
>  	struct snd_cx18_card *cxsc;
>  
>  	if (v4l2_dev == NULL) {
> -		printk(KERN_ERR "cx18-alsa: %s: struct v4l2_device * is NULL\n",
> -		       __func__);
> +		pr_err("%s: struct v4l2_device * is NULL\n", __func__);
>  		return 0;
>  	}
>  
> @@ -281,14 +281,14 @@ static void __exit cx18_alsa_exit(void)
>  	struct device_driver *drv;
>  	int ret;
>  
> -	printk(KERN_INFO "cx18-alsa: module unloading...\n");
> +	pr_info("module unloading...\n");
>  
>  	drv = driver_find("cx18", &pci_bus_type);
>  	ret = driver_for_each_device(drv, NULL, NULL, cx18_alsa_exit_callback);
>  	put_driver(drv);
>  
>  	cx18_ext_init = NULL;
> -	printk(KERN_INFO "cx18-alsa: module unload complete\n");
> +	pr_info("module unload complete\n");
>  }
>  
>  module_init(cx18_alsa_init);
> diff --git a/drivers/media/video/cx18/cx18-alsa-mixer.c b/drivers/media/video/cx18/cx18-alsa-mixer.c
> index 341bddc..551bd1a 100644
> --- a/drivers/media/video/cx18/cx18-alsa-mixer.c
> +++ b/drivers/media/video/cx18/cx18-alsa-mixer.c
> @@ -20,6 +20,8 @@
>   *  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/device.h>
> diff --git a/drivers/media/video/cx18/cx18-alsa-pcm.c b/drivers/media/video/cx18/cx18-alsa-pcm.c
> index 82d195b..e3528f6 100644
> --- a/drivers/media/video/cx18/cx18-alsa-pcm.c
> +++ b/drivers/media/video/cx18/cx18-alsa-pcm.c
> @@ -23,6 +23,8 @@
>   *  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/vmalloc.h>
> @@ -42,11 +44,11 @@ static unsigned int pcm_debug;
>  module_param(pcm_debug, int, 0644);
>  MODULE_PARM_DESC(pcm_debug, "enable debug messages for pcm");
>  
> -#define dprintk(fmt, arg...) do {					\
> -	    if (pcm_debug)						\
> -		printk(KERN_INFO "cx18-alsa-pcm %s: " fmt,		\
> -				  __func__, ##arg); 			\
> -	} while (0)
> +#define dprintk(fmt, ...)					\
> +do {								\
> +	if (pcm_debug)						\
> +		pr_info("%s: " fmt, __func__, ##__VA_ARGS__);	\
> +} while (0)
>  
>  static struct snd_pcm_hardware snd_cx18_hw_capture = {
>  	.info = SNDRV_PCM_INFO_BLOCK_TRANSFER |
> diff --git a/drivers/media/video/cx18/cx18-alsa.h b/drivers/media/video/cx18/cx18-alsa.h
> index 447da37..3c16b30 100644
> --- a/drivers/media/video/cx18/cx18-alsa.h
> +++ b/drivers/media/video/cx18/cx18-alsa.h
> @@ -52,24 +52,24 @@ static inline void snd_cx18_unlock(struct snd_cx18_card *cxsc)
>  #define CX18_ALSA_DBGFLG_WARN  (1 << 0)
>  #define CX18_ALSA_DBGFLG_INFO  (1 << 1)
>  
> -#define CX18_ALSA_DEBUG(x, type, fmt, args...) \
> -	do { \
> -		if ((x) & cx18_alsa_debug) \
> -			printk(KERN_INFO "%s-alsa: " type ": " fmt, \
> -				v4l2_dev->name , ## args); \
> -	} while (0)
> +#define CX18_ALSA_DEBUG(x, type, fmt, ...)				\
> +do {									\
> +	if ((x) & cx18_alsa_debug)					\
> +		pr_info("%s-alsa: " type ": " fmt,			\
> +			v4l2_dev->name, ##__VA_ARGS__);			\
> +} while (0)
>  
> -#define CX18_ALSA_DEBUG_WARN(fmt, args...) \
> -	CX18_ALSA_DEBUG(CX18_ALSA_DBGFLG_WARN, "warning", fmt , ## args)
> +#define CX18_ALSA_DEBUG_WARN(fmt, ...)					\
> +	CX18_ALSA_DEBUG(CX18_ALSA_DBGFLG_WARN, "warning", fmt, ##__VA_ARGS__)
>  
> -#define CX18_ALSA_DEBUG_INFO(fmt, args...) \
> -	CX18_ALSA_DEBUG(CX18_ALSA_DBGFLG_INFO, "info", fmt , ## args)
> +#define CX18_ALSA_DEBUG_INFO(fmt, ...)					\
> +	CX18_ALSA_DEBUG(CX18_ALSA_DBGFLG_INFO, "info", fmt, ##__VA_ARGS__)
>  
> -#define CX18_ALSA_ERR(fmt, args...) \
> -	printk(KERN_ERR "%s-alsa: " fmt, v4l2_dev->name , ## args)
> +#define CX18_ALSA_ERR(fmt, ...)						\
> +	pr_err("%s-alsa: " fmt, v4l2_dev->name, ##__VA_ARGS__)
>  
> -#define CX18_ALSA_WARN(fmt, args...) \
> -	printk(KERN_WARNING "%s-alsa: " fmt, v4l2_dev->name , ## args)
> +#define CX18_ALSA_WARN(fmt, ...)					\
> +	pr_warn("%s-alsa: " fmt, v4l2_dev->name, ##__VA_ARGS__)
>  
> -#define CX18_ALSA_INFO(fmt, args...) \
> -	printk(KERN_INFO "%s-alsa: " fmt, v4l2_dev->name , ## args)
> +#define CX18_ALSA_INFO(fmt, ...)					\
> +	pr_info("%s-alsa: " fmt, v4l2_dev->name, ##__VA_ARGS__)
> diff --git a/drivers/media/video/cx18/cx18-audio.c b/drivers/media/video/cx18/cx18-audio.c
> index 3526892..20ec9ff 100644
> --- a/drivers/media/video/cx18/cx18-audio.c
> +++ b/drivers/media/video/cx18/cx18-audio.c
> @@ -21,6 +21,8 @@
>   *  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "cx18-driver.h"
>  #include "cx18-io.h"
>  #include "cx18-cards.h"
> diff --git a/drivers/media/video/cx18/cx18-av-audio.c b/drivers/media/video/cx18/cx18-av-audio.c
> index 4a24ffb..4e39e6e 100644
> --- a/drivers/media/video/cx18/cx18-av-audio.c
> +++ b/drivers/media/video/cx18/cx18-av-audio.c
> @@ -22,6 +22,8 @@
>   *  02110-1301, USA.
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "cx18-driver.h"
>  
>  static int set_audclk_freq(struct cx18 *cx, u32 freq)
> diff --git a/drivers/media/video/cx18/cx18-av-core.c b/drivers/media/video/cx18/cx18-av-core.c
> index f164b7f..50a9118 100644
> --- a/drivers/media/video/cx18/cx18-av-core.c
> +++ b/drivers/media/video/cx18/cx18-av-core.c
> @@ -22,6 +22,8 @@
>   *  02110-1301, USA.
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <media/v4l2-chip-ident.h>
>  #include "cx18-driver.h"
>  #include "cx18-io.h"
> diff --git a/drivers/media/video/cx18/cx18-av-firmware.c b/drivers/media/video/cx18/cx18-av-firmware.c
> index 280aa4d..f2c8a3b 100644
> --- a/drivers/media/video/cx18/cx18-av-firmware.c
> +++ b/drivers/media/video/cx18/cx18-av-firmware.c
> @@ -20,6 +20,8 @@
>   *  02110-1301, USA.
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "cx18-driver.h"
>  #include "cx18-io.h"
>  #include <linux/firmware.h>
> diff --git a/drivers/media/video/cx18/cx18-av-vbi.c b/drivers/media/video/cx18/cx18-av-vbi.c
> index baa36fb..26b2013 100644
> --- a/drivers/media/video/cx18/cx18-av-vbi.c
> +++ b/drivers/media/video/cx18/cx18-av-vbi.c
> @@ -21,6 +21,7 @@
>   *  02110-1301, USA.
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
>  #include "cx18-driver.h"
>  
> diff --git a/drivers/media/video/cx18/cx18-controls.c b/drivers/media/video/cx18/cx18-controls.c
> index 282a3d2..e0adc95 100644
> --- a/drivers/media/video/cx18/cx18-controls.c
> +++ b/drivers/media/video/cx18/cx18-controls.c
> @@ -20,6 +20,9 @@
>   *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
>   *  02111-1307  USA
>   */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/kernel.h>
>  #include <linux/slab.h>
>  
> diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
> index 9e2f870..8a83d0b 100644
> --- a/drivers/media/video/cx18/cx18-driver.c
> +++ b/drivers/media/video/cx18/cx18-driver.c
> @@ -22,6 +22,8 @@
>   *  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "cx18-driver.h"
>  #include "cx18-io.h"
>  #include "cx18-version.h"
> @@ -315,9 +317,9 @@ static void cx18_eeprom_dump(struct cx18 *cx, unsigned char *eedata, int len)
>  	for (i = 0; i < len; i++) {
>  		if (0 == (i % 16))
>  			CX18_INFO("eeprom %02x:", i);
> -		printk(KERN_CONT " %02x", eedata[i]);
> +		pr_cont(" %02x", eedata[i]);
>  		if (15 == (i % 16))
> -			printk(KERN_CONT "\n");
> +			pr_cont("\n");
>  	}
>  }
>  
> @@ -684,7 +686,7 @@ done:
>  		CX18_ERR("Defaulting to %s card\n", cx->card->name);
>  		CX18_ERR("Please mail the vendor/device and subsystem vendor/device IDs and what kind of\n");
>  		CX18_ERR("card you have to the ivtv-devel mailinglist (www.ivtvdriver.org)\n");
> -		CX18_ERR("Prefix your subject line with [UNKNOWN CX18 CARD].\n");
> +		CX18_ERR("Prefix your subject line with [UNKNOWN CX18 CARD]\n");
>  	}
>  	cx->v4l2_cap = cx->card->v4l2_capabilities;
>  	cx->card_name = cx->card->name;
> @@ -903,15 +905,14 @@ static int __devinit cx18_probe(struct pci_dev *pci_dev,
>  	/* FIXME - module parameter arrays constrain max instances */
>  	i = atomic_inc_return(&cx18_instance) - 1;
>  	if (i >= CX18_MAX_CARDS) {
> -		printk(KERN_ERR "cx18: cannot manage card %d, driver has a "
> -		       "limit of 0 - %d\n", i, CX18_MAX_CARDS - 1);
> +		pr_err("cannot manage card %d, driver has a limit of 0 - %d\n",
> +		       i, CX18_MAX_CARDS - 1);
>  		return -ENOMEM;
>  	}
>  
>  	cx = kzalloc(sizeof(struct cx18), GFP_ATOMIC);
>  	if (cx == NULL) {
> -		printk(KERN_ERR "cx18: cannot manage card %d, out of memory\n",
> -		       i);
> +		pr_err("cannot manage card %d, out of memory\n", i);
>  		return -ENOMEM;
>  	}
>  	cx->pci_dev = pci_dev;
> @@ -919,8 +920,8 @@ static int __devinit cx18_probe(struct pci_dev *pci_dev,
>  
>  	retval = v4l2_device_register(&pci_dev->dev, &cx->v4l2_dev);
>  	if (retval) {
> -		printk(KERN_ERR "cx18: v4l2_device_register of card %d failed"
> -		       "\n", cx->instance);
> +		pr_err("v4l2_device_register of card %d failed\n",
> +		       cx->instance);
>  		kfree(cx);
>  		return retval;
>  	}
> @@ -993,8 +994,7 @@ static int __devinit cx18_probe(struct pci_dev *pci_dev,
>  	/* Initialize GPIO Reset Controller to do chip resets during i2c init */
>  	if (cx->card->hw_all & CX18_HW_GPIO_RESET_CTRL) {
>  		if (cx18_gpio_register(cx, CX18_HW_GPIO_RESET_CTRL) != 0)
> -			CX18_WARN("Could not register GPIO reset controller"
> -				  "subdevice; proceeding anyway.\n");
> +			CX18_WARN("Could not register GPIO reset controller subdevice; proceeding anyway.\n");
>  		else
>  			cx->hw_flags |= CX18_HW_GPIO_RESET_CTRL;
>  	}
> @@ -1325,26 +1325,25 @@ static struct pci_driver cx18_pci_driver = {
>  
>  static int __init module_start(void)
>  {
> -	printk(KERN_INFO "cx18:  Start initialization, version %s\n",
> -	       CX18_VERSION);
> +	pr_info(" Start initialization, version %s\n", CX18_VERSION);
>  
>  	/* Validate parameters */
>  	if (cx18_first_minor < 0 || cx18_first_minor >= CX18_MAX_CARDS) {
> -		printk(KERN_ERR "cx18:  Exiting, cx18_first_minor must be between 0 and %d\n",
> -		     CX18_MAX_CARDS - 1);
> +		pr_err(" Exiting, cx18_first_minor must be between 0 and %d\n",
> +		       CX18_MAX_CARDS - 1);
>  		return -1;
>  	}
>  
>  	if (cx18_debug < 0 || cx18_debug > 511) {
>  		cx18_debug = 0;
> -		printk(KERN_INFO "cx18:   Debug value must be >= 0 and <= 511!\n");
> +		pr_info("  Debug value must be >= 0 and <= 511!\n");
>  	}
>  
>  	if (pci_register_driver(&cx18_pci_driver)) {
> -		printk(KERN_ERR "cx18:   Error detecting PCI card\n");
> +		pr_err("  Error detecting PCI card\n");
>  		return -ENODEV;
>  	}
> -	printk(KERN_INFO "cx18:  End initialization\n");
> +	pr_info(" End initialization\n");
>  	return 0;
>  }
>  
> diff --git a/drivers/media/video/cx18/cx18-driver.h b/drivers/media/video/cx18/cx18-driver.h
> index 1834207..68a0d5c 100644
> --- a/drivers/media/video/cx18/cx18-driver.h
> +++ b/drivers/media/video/cx18/cx18-driver.h
> @@ -170,89 +170,114 @@ struct cx18_enc_idx_entry {
>  /* Flag to turn on high volume debugging */
>  #define CX18_DBGFLG_HIGHVOL (1 << 8)
>  
> -/* NOTE: extra space before comma in 'fmt , ## args' is required for
> -   gcc-2.95, otherwise it won't compile. */
> -#define CX18_DEBUG(x, type, fmt, args...) \
> -	do { \
> -		if ((x) & cx18_debug) \
> -			v4l2_info(&cx->v4l2_dev, " " type ": " fmt , ## args); \
> -	} while (0)
> -#define CX18_DEBUG_WARN(fmt, args...)  CX18_DEBUG(CX18_DBGFLG_WARN, "warning", fmt , ## args)
> -#define CX18_DEBUG_INFO(fmt, args...)  CX18_DEBUG(CX18_DBGFLG_INFO, "info", fmt , ## args)
> -#define CX18_DEBUG_API(fmt, args...)   CX18_DEBUG(CX18_DBGFLG_API, "api", fmt , ## args)
> -#define CX18_DEBUG_DMA(fmt, args...)   CX18_DEBUG(CX18_DBGFLG_DMA, "dma", fmt , ## args)
> -#define CX18_DEBUG_IOCTL(fmt, args...) CX18_DEBUG(CX18_DBGFLG_IOCTL, "ioctl", fmt , ## args)
> -#define CX18_DEBUG_FILE(fmt, args...)  CX18_DEBUG(CX18_DBGFLG_FILE, "file", fmt , ## args)
> -#define CX18_DEBUG_I2C(fmt, args...)   CX18_DEBUG(CX18_DBGFLG_I2C, "i2c", fmt , ## args)
> -#define CX18_DEBUG_IRQ(fmt, args...)   CX18_DEBUG(CX18_DBGFLG_IRQ, "irq", fmt , ## args)
> -
> -#define CX18_DEBUG_HIGH_VOL(x, type, fmt, args...) \
> -	do { \
> -		if (((x) & cx18_debug) && (cx18_debug & CX18_DBGFLG_HIGHVOL)) \
> -			v4l2_info(&cx->v4l2_dev, " " type ": " fmt , ## args); \
> -	} while (0)
> -#define CX18_DEBUG_HI_WARN(fmt, args...)  CX18_DEBUG_HIGH_VOL(CX18_DBGFLG_WARN, "warning", fmt , ## args)
> -#define CX18_DEBUG_HI_INFO(fmt, args...)  CX18_DEBUG_HIGH_VOL(CX18_DBGFLG_INFO, "info", fmt , ## args)
> -#define CX18_DEBUG_HI_API(fmt, args...)   CX18_DEBUG_HIGH_VOL(CX18_DBGFLG_API, "api", fmt , ## args)
> -#define CX18_DEBUG_HI_DMA(fmt, args...)   CX18_DEBUG_HIGH_VOL(CX18_DBGFLG_DMA, "dma", fmt , ## args)
> -#define CX18_DEBUG_HI_IOCTL(fmt, args...) CX18_DEBUG_HIGH_VOL(CX18_DBGFLG_IOCTL, "ioctl", fmt , ## args)
> -#define CX18_DEBUG_HI_FILE(fmt, args...)  CX18_DEBUG_HIGH_VOL(CX18_DBGFLG_FILE, "file", fmt , ## args)
> -#define CX18_DEBUG_HI_I2C(fmt, args...)   CX18_DEBUG_HIGH_VOL(CX18_DBGFLG_I2C, "i2c", fmt , ## args)
> -#define CX18_DEBUG_HI_IRQ(fmt, args...)   CX18_DEBUG_HIGH_VOL(CX18_DBGFLG_IRQ, "irq", fmt , ## args)
> +#define CX18_DEBUG(x, type, fmt, ...)					\
> +do {									\
> +	if ((x) & cx18_debug)						\
> +		v4l2_info(&cx->v4l2_dev, " " type ": " fmt, ##__VA_ARGS__); \
> +} while (0)
> +#define CX18_DEBUG_WARN(fmt, ...)					\
> +	CX18_DEBUG(CX18_DBGFLG_WARN, "warning", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_INFO(fmt, ...)					\
> +	CX18_DEBUG(CX18_DBGFLG_INFO, "info", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_API(fmt, ...)					\
> +	CX18_DEBUG(CX18_DBGFLG_API, "api", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_DMA(fmt, ...)					\
> +	CX18_DEBUG(CX18_DBGFLG_DMA, "dma", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_IOCTL(fmt, ...)					\
> +	CX18_DEBUG(CX18_DBGFLG_IOCTL, "ioctl", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_FILE(fmt, ...)					\
> +	CX18_DEBUG(CX18_DBGFLG_FILE, "file", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_I2C(fmt, ...)					\
> +	CX18_DEBUG(CX18_DBGFLG_I2C, "i2c", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_IRQ(fmt, ...)					\
> +	CX18_DEBUG(CX18_DBGFLG_IRQ, "irq", fmt, ##__VA_ARGS__)
> +
> +#define CX18_DEBUG_HIGH_VOL(x, type, fmt, ...)				\
> +do {									\
> +	if (((x) & cx18_debug) && (cx18_debug & CX18_DBGFLG_HIGHVOL))	\
> +		v4l2_info(&cx->v4l2_dev, " " type ": " fmt, ##__VA_ARGS__); \
> +} while (0)
> +#define CX18_DEBUG_HI_WARN(fmt, ...)					\
> +	CX18_DEBUG_HIGH_VOL(CX18_DBGFLG_WARN, "warning", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_HI_INFO(fmt, ...)					\
> +	CX18_DEBUG_HIGH_VOL(CX18_DBGFLG_INFO, "info", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_HI_API(fmt, ...)					\
> +	CX18_DEBUG_HIGH_VOL(CX18_DBGFLG_API, "api", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_HI_DMA(fmt, ...)					\
> +	CX18_DEBUG_HIGH_VOL(CX18_DBGFLG_DMA, "dma", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_HI_IOCTL(fmt, ...)					\
> +	CX18_DEBUG_HIGH_VOL(CX18_DBGFLG_IOCTL, "ioctl", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_HI_FILE(fmt, ...)					\
> +	CX18_DEBUG_HIGH_VOL(CX18_DBGFLG_FILE, "file", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_HI_I2C(fmt, ...)					\
> +	CX18_DEBUG_HIGH_VOL(CX18_DBGFLG_I2C, "i2c", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_HI_IRQ(fmt, ...)					\
> +	CX18_DEBUG_HIGH_VOL(CX18_DBGFLG_IRQ, "irq", fmt, ##__VA_ARGS__)
>  
>  /* Standard kernel messages */
> -#define CX18_ERR(fmt, args...)      v4l2_err(&cx->v4l2_dev, fmt , ## args)
> -#define CX18_WARN(fmt, args...)     v4l2_warn(&cx->v4l2_dev, fmt , ## args)
> -#define CX18_INFO(fmt, args...)     v4l2_info(&cx->v4l2_dev, fmt , ## args)
> +#define CX18_ERR(fmt, ...)      v4l2_err(&cx->v4l2_dev, fmt, ##__VA_ARGS__)
> +#define CX18_WARN(fmt, ...)     v4l2_warn(&cx->v4l2_dev, fmt, ##__VA_ARGS__)
> +#define CX18_INFO(fmt, ...)     v4l2_info(&cx->v4l2_dev, fmt, ##__VA_ARGS__)
>  
>  /* Messages for internal subdevs to use */
> -#define CX18_DEBUG_DEV(x, dev, type, fmt, args...) \
> -	do { \
> -		if ((x) & cx18_debug) \
> -			v4l2_info(dev, " " type ": " fmt , ## args); \
> -	} while (0)
> -#define CX18_DEBUG_WARN_DEV(dev, fmt, args...) \
> -		CX18_DEBUG_DEV(CX18_DBGFLG_WARN, dev, "warning", fmt , ## args)
> -#define CX18_DEBUG_INFO_DEV(dev, fmt, args...) \
> -		CX18_DEBUG_DEV(CX18_DBGFLG_INFO, dev, "info", fmt , ## args)
> -#define CX18_DEBUG_API_DEV(dev, fmt, args...) \
> -		CX18_DEBUG_DEV(CX18_DBGFLG_API, dev, "api", fmt , ## args)
> -#define CX18_DEBUG_DMA_DEV(dev, fmt, args...) \
> -		CX18_DEBUG_DEV(CX18_DBGFLG_DMA, dev, "dma", fmt , ## args)
> -#define CX18_DEBUG_IOCTL_DEV(dev, fmt, args...) \
> -		CX18_DEBUG_DEV(CX18_DBGFLG_IOCTL, dev, "ioctl", fmt , ## args)
> -#define CX18_DEBUG_FILE_DEV(dev, fmt, args...) \
> -		CX18_DEBUG_DEV(CX18_DBGFLG_FILE, dev, "file", fmt , ## args)
> -#define CX18_DEBUG_I2C_DEV(dev, fmt, args...) \
> -		CX18_DEBUG_DEV(CX18_DBGFLG_I2C, dev, "i2c", fmt , ## args)
> -#define CX18_DEBUG_IRQ_DEV(dev, fmt, args...) \
> -		CX18_DEBUG_DEV(CX18_DBGFLG_IRQ, dev, "irq", fmt , ## args)
> -
> -#define CX18_DEBUG_HIGH_VOL_DEV(x, dev, type, fmt, args...) \
> -	do { \
> -		if (((x) & cx18_debug) && (cx18_debug & CX18_DBGFLG_HIGHVOL)) \
> -			v4l2_info(dev, " " type ": " fmt , ## args); \
> -	} while (0)
> -#define CX18_DEBUG_HI_WARN_DEV(dev, fmt, args...) \
> -	CX18_DEBUG_HIGH_VOL_DEV(CX18_DBGFLG_WARN, dev, "warning", fmt , ## args)
> -#define CX18_DEBUG_HI_INFO_DEV(dev, fmt, args...) \
> -	CX18_DEBUG_HIGH_VOL_DEV(CX18_DBGFLG_INFO, dev, "info", fmt , ## args)
> -#define CX18_DEBUG_HI_API_DEV(dev, fmt, args...) \
> -	CX18_DEBUG_HIGH_VOL_DEV(CX18_DBGFLG_API, dev, "api", fmt , ## args)
> -#define CX18_DEBUG_HI_DMA_DEV(dev, fmt, args...) \
> -	CX18_DEBUG_HIGH_VOL_DEV(CX18_DBGFLG_DMA, dev, "dma", fmt , ## args)
> -#define CX18_DEBUG_HI_IOCTL_DEV(dev, fmt, args...) \
> -	CX18_DEBUG_HIGH_VOL_DEV(CX18_DBGFLG_IOCTL, dev, "ioctl", fmt , ## args)
> -#define CX18_DEBUG_HI_FILE_DEV(dev, fmt, args...) \
> -	CX18_DEBUG_HIGH_VOL_DEV(CX18_DBGFLG_FILE, dev, "file", fmt , ## args)
> -#define CX18_DEBUG_HI_I2C_DEV(dev, fmt, args...) \
> -	CX18_DEBUG_HIGH_VOL_DEV(CX18_DBGFLG_I2C, dev, "i2c", fmt , ## args)
> -#define CX18_DEBUG_HI_IRQ_DEV(dev, fmt, args...) \
> -	CX18_DEBUG_HIGH_VOL_DEV(CX18_DBGFLG_IRQ, dev, "irq", fmt , ## args)
> -
> -#define CX18_ERR_DEV(dev, fmt, args...)      v4l2_err(dev, fmt , ## args)
> -#define CX18_WARN_DEV(dev, fmt, args...)     v4l2_warn(dev, fmt , ## args)
> -#define CX18_INFO_DEV(dev, fmt, args...)     v4l2_info(dev, fmt , ## args)
> +#define CX18_DEBUG_DEV(x, dev, type, fmt, ...)			     \
> +do {								     \
> +	if ((x) & cx18_debug)					     \
> +		v4l2_info(dev, " " type ": " fmt, ##__VA_ARGS__);    \
> +} while (0)
> +#define CX18_DEBUG_WARN_DEV(dev, fmt, ...)				\
> +	CX18_DEBUG_DEV(CX18_DBGFLG_WARN, dev, "warning", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_INFO_DEV(dev, fmt, ...)				\
> +	CX18_DEBUG_DEV(CX18_DBGFLG_INFO, dev, "info", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_API_DEV(dev, fmt, ...)				\
> +	CX18_DEBUG_DEV(CX18_DBGFLG_API, dev, "api", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_DMA_DEV(dev, fmt, ...)				\
> +	CX18_DEBUG_DEV(CX18_DBGFLG_DMA, dev, "dma", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_IOCTL_DEV(dev, fmt, ...)				\
> +	CX18_DEBUG_DEV(CX18_DBGFLG_IOCTL, dev, "ioctl", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_FILE_DEV(dev, fmt, ...)				\
> +	CX18_DEBUG_DEV(CX18_DBGFLG_FILE, dev, "file", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_I2C_DEV(dev, fmt, ...)				\
> +	CX18_DEBUG_DEV(CX18_DBGFLG_I2C, dev, "i2c", fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_IRQ_DEV(dev, fmt, ...)				\
> +	CX18_DEBUG_DEV(CX18_DBGFLG_IRQ, dev, "irq", fmt, ##__VA_ARGS__)
> +
> +#define CX18_DEBUG_HIGH_VOL_DEV(x, dev, type, fmt, ...)			\
> +do {									\
> +	if (((x) & cx18_debug) && (cx18_debug & CX18_DBGFLG_HIGHVOL))	\
> +		v4l2_info(dev, " " type ": " fmt, ##__VA_ARGS__);	\
> +} while (0)
> +#define CX18_DEBUG_HI_WARN_DEV(dev, fmt, ...)				\
> +	CX18_DEBUG_HIGH_VOL_DEV(CX18_DBGFLG_WARN, dev, "warning",	\
> +				fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_HI_INFO_DEV(dev, fmt, ...)				\
> +	CX18_DEBUG_HIGH_VOL_DEV(CX18_DBGFLG_INFO, dev, "info",		\
> +				fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_HI_API_DEV(dev, fmt, ...)				\
> +	CX18_DEBUG_HIGH_VOL_DEV(CX18_DBGFLG_API, dev, "api",		\
> +				fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_HI_DMA_DEV(dev, fmt, ...)				\
> +	CX18_DEBUG_HIGH_VOL_DEV(CX18_DBGFLG_DMA, dev, "dma",		\
> +				fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_HI_IOCTL_DEV(dev, fmt, ...)				\
> +	CX18_DEBUG_HIGH_VOL_DEV(CX18_DBGFLG_IOCTL, dev, "ioctl",	\
> +				fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_HI_FILE_DEV(dev, fmt, ...)				\
> +	CX18_DEBUG_HIGH_VOL_DEV(CX18_DBGFLG_FILE, dev, "file",		\
> +				fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_HI_I2C_DEV(dev, fmt, ...)				\
> +	CX18_DEBUG_HIGH_VOL_DEV(CX18_DBGFLG_I2C, dev, "i2c",		\
> +				fmt, ##__VA_ARGS__)
> +#define CX18_DEBUG_HI_IRQ_DEV(dev, fmt, ...)				\
> +	CX18_DEBUG_HIGH_VOL_DEV(CX18_DBGFLG_IRQ, dev, "irq",		\
> +				fmt, ##__VA_ARGS__)
> +
> +#define CX18_ERR_DEV(dev, fmt, ...)		\
> +	v4l2_err(dev, fmt, ##__VA_ARGS__)
> +#define CX18_WARN_DEV(dev, fmt, ...)		\
> +	v4l2_warn(dev, fmt, ##__VA_ARGS__)
> +#define CX18_INFO_DEV(dev, fmt, ...)		\
> +	v4l2_info(dev, fmt, ##__VA_ARGS__)
>  
>  extern int cx18_debug;
>  
> diff --git a/drivers/media/video/cx18/cx18-dvb.c b/drivers/media/video/cx18/cx18-dvb.c
> index f41922b..078ffe9 100644
> --- a/drivers/media/video/cx18/cx18-dvb.c
> +++ b/drivers/media/video/cx18/cx18-dvb.c
> @@ -20,6 +20,8 @@
>   *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "cx18-version.h"
>  #include "cx18-dvb.h"
>  #include "cx18-io.h"
> diff --git a/drivers/media/video/cx18/cx18-fileops.c b/drivers/media/video/cx18/cx18-fileops.c
> index 07411f3..bc4339d 100644
> --- a/drivers/media/video/cx18/cx18-fileops.c
> +++ b/drivers/media/video/cx18/cx18-fileops.c
> @@ -22,6 +22,8 @@
>   *  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "cx18-driver.h"
>  #include "cx18-fileops.h"
>  #include "cx18-i2c.h"
> @@ -48,8 +50,7 @@ int cx18_claim_stream(struct cx18_open_id *id, int type)
>  
>  	/* Nothing should ever try to directly claim the IDX stream */
>  	if (type == CX18_ENC_STREAM_TYPE_IDX) {
> -		CX18_WARN("MPEG Index stream cannot be claimed "
> -			  "directly, but something tried.\n");
> +		CX18_WARN("MPEG Index stream cannot be claimed directly, but something tried\n");
>  		return -EINVAL;
>  	}
>  
> @@ -173,8 +174,8 @@ static void cx18_dualwatch(struct cx18 *cx)
>  	if (new_stereo_mode == cx->dualwatch_stereo_mode)
>  		return;
>  
> -	CX18_DEBUG_INFO("dualwatch: change stereo flag from 0x%x to 0x%x.\n",
> -			   cx->dualwatch_stereo_mode, new_stereo_mode);
> +	CX18_DEBUG_INFO("dualwatch: change stereo flag from 0x%x to 0x%x\n",
> +			cx->dualwatch_stereo_mode, new_stereo_mode);
>  	if (v4l2_ctrl_s_ctrl(cx->cxhdl.audio_mode, new_stereo_mode))
>  		CX18_DEBUG_INFO("dualwatch: changing stereo flag failed\n");
>  }
> diff --git a/drivers/media/video/cx18/cx18-firmware.c b/drivers/media/video/cx18/cx18-firmware.c
> index 1b3fb50..8418b6e 100644
> --- a/drivers/media/video/cx18/cx18-firmware.c
> +++ b/drivers/media/video/cx18/cx18-firmware.c
> @@ -20,6 +20,8 @@
>   *  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "cx18-driver.h"
>  #include "cx18-io.h"
>  #include "cx18-scb.h"
> @@ -207,7 +209,7 @@ static int load_apu_fw_direct(const char *fn, u8 __iomem *dst, struct cx18 *cx,
>  
>  void cx18_halt_firmware(struct cx18 *cx)
>  {
> -	CX18_DEBUG_INFO("Preparing for firmware halt.\n");
> +	CX18_DEBUG_INFO("Preparing for firmware halt\n");
>  	cx18_write_reg_expect(cx, 0x000F000F, CX18_PROC_SOFT_RESET,
>  				  0x0000000F, 0x000F000F);
>  	cx18_write_reg_expect(cx, 0x00020002, CX18_ADEC_CONTROL,
> diff --git a/drivers/media/video/cx18/cx18-gpio.c b/drivers/media/video/cx18/cx18-gpio.c
> index 5374aeb..c497265 100644
> --- a/drivers/media/video/cx18/cx18-gpio.c
> +++ b/drivers/media/video/cx18/cx18-gpio.c
> @@ -22,6 +22,8 @@
>   *  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "cx18-driver.h"
>  #include "cx18-io.h"
>  #include "cx18-cards.h"
> diff --git a/drivers/media/video/cx18/cx18-i2c.c b/drivers/media/video/cx18/cx18-i2c.c
> index 040aaa8..050220d 100644
> --- a/drivers/media/video/cx18/cx18-i2c.c
> +++ b/drivers/media/video/cx18/cx18-i2c.c
> @@ -22,6 +22,8 @@
>   *  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "cx18-driver.h"
>  #include "cx18-io.h"
>  #include "cx18-cards.h"
> diff --git a/drivers/media/video/cx18/cx18-io.c b/drivers/media/video/cx18/cx18-io.c
> index 49b9dbd..673f9f2 100644
> --- a/drivers/media/video/cx18/cx18-io.c
> +++ b/drivers/media/video/cx18/cx18-io.c
> @@ -20,6 +20,8 @@
>   *  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "cx18-driver.h"
>  #include "cx18-io.h"
>  #include "cx18-irq.h"
> diff --git a/drivers/media/video/cx18/cx18-ioctl.c b/drivers/media/video/cx18/cx18-ioctl.c
> index afe0a29..a83c7da 100644
> --- a/drivers/media/video/cx18/cx18-ioctl.c
> +++ b/drivers/media/video/cx18/cx18-ioctl.c
> @@ -22,6 +22,8 @@
>   *  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "cx18-driver.h"
>  #include "cx18-io.h"
>  #include "cx18-version.h"
> @@ -665,7 +667,7 @@ int cx18_s_std(struct file *file, void *fh, v4l2_std_id *std)
>  	cx->vbi.count = cx->is_50hz ? 18 : 12;
>  	cx->vbi.start[0] = cx->is_50hz ? 6 : 10;
>  	cx->vbi.start[1] = cx->is_50hz ? 318 : 273;
> -	CX18_DEBUG_INFO("Switching standard to %llx.\n",
> +	CX18_DEBUG_INFO("Switching standard to %llx\n",
>  			(unsigned long long) cx->std);
>  
>  	/* Tuner */
> diff --git a/drivers/media/video/cx18/cx18-irq.c b/drivers/media/video/cx18/cx18-irq.c
> index 80edfe9..c33b145 100644
> --- a/drivers/media/video/cx18/cx18-irq.c
> +++ b/drivers/media/video/cx18/cx18-irq.c
> @@ -20,6 +20,8 @@
>   *  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "cx18-driver.h"
>  #include "cx18-io.h"
>  #include "cx18-irq.h"
> diff --git a/drivers/media/video/cx18/cx18-mailbox.c b/drivers/media/video/cx18/cx18-mailbox.c
> index c07191e..fcc47cc 100644
> --- a/drivers/media/video/cx18/cx18-mailbox.c
> +++ b/drivers/media/video/cx18/cx18-mailbox.c
> @@ -20,6 +20,8 @@
>   *  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <stdarg.h>
>  
>  #include "cx18-driver.h"
> diff --git a/drivers/media/video/cx18/cx18-queue.c b/drivers/media/video/cx18/cx18-queue.c
> index 8884537..f3fd4ce 100644
> --- a/drivers/media/video/cx18/cx18-queue.c
> +++ b/drivers/media/video/cx18/cx18-queue.c
> @@ -22,6 +22,8 @@
>   *  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "cx18-driver.h"
>  #include "cx18-queue.h"
>  #include "cx18-streams.h"
> diff --git a/drivers/media/video/cx18/cx18-scb.c b/drivers/media/video/cx18/cx18-scb.c
> index 85cc596..7ccbc9c 100644
> --- a/drivers/media/video/cx18/cx18-scb.c
> +++ b/drivers/media/video/cx18/cx18-scb.c
> @@ -20,6 +20,8 @@
>   *  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "cx18-driver.h"
>  #include "cx18-io.h"
>  #include "cx18-scb.h"
> diff --git a/drivers/media/video/cx18/cx18-streams.c b/drivers/media/video/cx18/cx18-streams.c
> index 852f420..470ac88 100644
> --- a/drivers/media/video/cx18/cx18-streams.c
> +++ b/drivers/media/video/cx18/cx18-streams.c
> @@ -22,6 +22,8 @@
>   *  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "cx18-driver.h"
>  #include "cx18-io.h"
>  #include "cx18-fileops.h"
> diff --git a/drivers/media/video/cx18/cx18-vbi.c b/drivers/media/video/cx18/cx18-vbi.c
> index 6d3121f..930fd01 100644
> --- a/drivers/media/video/cx18/cx18-vbi.c
> +++ b/drivers/media/video/cx18/cx18-vbi.c
> @@ -21,6 +21,8 @@
>   *  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "cx18-driver.h"
>  #include "cx18-vbi.h"
>  #include "cx18-ioctl.h"
> diff --git a/drivers/media/video/cx18/cx18-video.c b/drivers/media/video/cx18/cx18-video.c
> index 6dc84aa..797b13f 100644
> --- a/drivers/media/video/cx18/cx18-video.c
> +++ b/drivers/media/video/cx18/cx18-video.c
> @@ -19,6 +19,8 @@
>   *  02111-1307  USA
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "cx18-driver.h"
>  #include "cx18-video.h"
>  #include "cx18-cards.h"


