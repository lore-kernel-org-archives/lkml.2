Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1HVG2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 02:28:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37301 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab1HVG2Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 02:28:16 -0400
MIME-Version: 1.0
In-Reply-To: <c2d8f9c52af1d1feb7948ba29447d082defbdd6a.1313966090.git.joe@perches.com>
References: <cover.1313966088.git.joe@perches.com>
	<c2d8f9c52af1d1feb7948ba29447d082defbdd6a.1313966090.git.joe@perches.com>
Date: Mon, 22 Aug 2011 08:28:13 +0200
Message-ID: <CAMyVd1p_ZEHMyRSV8PYCgG-uTHAw8K3gWgMLEq5h6c5ofXS3nQ@mail.gmail.com>
Subject: Re: [PATCH 09/14] [media] m5602: Use current logging styles
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/22 Joe Perches <joe@perches.com>:
> Add pr_fmt and convert usb style logging macro uses to pr_<level>.
> Coalesce format strings.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/media/video/gspca/m5602/m5602_core.c    |    9 +++--
>  drivers/media/video/gspca/m5602/m5602_mt9m111.c |   28 ++++++++++--------
>  drivers/media/video/gspca/m5602/m5602_ov7660.c  |   21 +++++++------
>  drivers/media/video/gspca/m5602/m5602_ov9650.c  |   19 ++++++------
>  drivers/media/video/gspca/m5602/m5602_po1030.c  |   21 +++++++------
>  drivers/media/video/gspca/m5602/m5602_s5k4aa.c  |   35 +++++++++++++----------
>  drivers/media/video/gspca/m5602/m5602_s5k83a.c  |   30 +++++++++++--------
>  7 files changed, 89 insertions(+), 74 deletions(-)
>
> diff --git a/drivers/media/video/gspca/m5602/m5602_core.c b/drivers/media/video/gspca/m5602/m5602_core.c
> index a7722b1..67533e5 100644
> --- a/drivers/media/video/gspca/m5602/m5602_core.c
> +++ b/drivers/media/video/gspca/m5602/m5602_core.c
> @@ -16,6 +16,8 @@
>  *
>  */
>
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "m5602_ov9650.h"
>  #include "m5602_ov7660.h"
>  #include "m5602_mt9m111.h"
> @@ -192,10 +194,9 @@ static void m5602_dump_bridge(struct sd *sd)
>        for (i = 0; i < 0x80; i++) {
>                unsigned char val = 0;
>                m5602_read_bridge(sd, i, &val);
> -               info("ALi m5602 address 0x%x contains 0x%x", i, val);
> +               pr_info("ALi m5602 address 0x%x contains 0x%x\n", i, val);
>        }
> -       info("Warning: The ALi m5602 webcam probably won't work "
> -               "until it's power cycled");
> +       pr_info("Warning: The ALi m5602 webcam probably won't work until it's power cycled\n");
>  }
>
>  static int m5602_probe_sensor(struct sd *sd)
> @@ -231,7 +232,7 @@ static int m5602_probe_sensor(struct sd *sd)
>                return 0;
>
>        /* More sensor probe function goes here */
> -       info("Failed to find a sensor");
> +       pr_info("Failed to find a sensor\n");
>        sd->sensor = NULL;
>        return -ENODEV;
>  }
> diff --git a/drivers/media/video/gspca/m5602/m5602_mt9m111.c b/drivers/media/video/gspca/m5602/m5602_mt9m111.c
> index 0d605a5..6268aa2 100644
> --- a/drivers/media/video/gspca/m5602/m5602_mt9m111.c
> +++ b/drivers/media/video/gspca/m5602/m5602_mt9m111.c
> @@ -16,6 +16,8 @@
>  *
>  */
>
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "m5602_mt9m111.h"
>
>  static int mt9m111_set_vflip(struct gspca_dev *gspca_dev, __s32 val);
> @@ -163,7 +165,7 @@ int mt9m111_probe(struct sd *sd)
>
>        if (force_sensor) {
>                if (force_sensor == MT9M111_SENSOR) {
> -                       info("Forcing a %s sensor", mt9m111.name);
> +                       pr_info("Forcing a %s sensor\n", mt9m111.name);
>                        goto sensor_found;
>                }
>                /* If we want to force another sensor, don't try to probe this
> @@ -191,7 +193,7 @@ int mt9m111_probe(struct sd *sd)
>                return -ENODEV;
>
>        if ((data[0] == 0x14) && (data[1] == 0x3a)) {
> -               info("Detected a mt9m111 sensor");
> +               pr_info("Detected a mt9m111 sensor\n");
>                goto sensor_found;
>        }
>
> @@ -612,34 +614,34 @@ static void mt9m111_dump_registers(struct sd *sd)
>  {
>        u8 address, value[2] = {0x00, 0x00};
>
> -       info("Dumping the mt9m111 register state");
> +       pr_info("Dumping the mt9m111 register state\n");
>
> -       info("Dumping the mt9m111 sensor core registers");
> +       pr_info("Dumping the mt9m111 sensor core registers\n");
>        value[1] = MT9M111_SENSOR_CORE;
>        m5602_write_sensor(sd, MT9M111_PAGE_MAP, value, 2);
>        for (address = 0; address < 0xff; address++) {
>                m5602_read_sensor(sd, address, value, 2);
> -               info("register 0x%x contains 0x%x%x",
> -                    address, value[0], value[1]);
> +               pr_info("register 0x%x contains 0x%x%x\n",
> +                       address, value[0], value[1]);
>        }
>
> -       info("Dumping the mt9m111 color pipeline registers");
> +       pr_info("Dumping the mt9m111 color pipeline registers\n");
>        value[1] = MT9M111_COLORPIPE;
>        m5602_write_sensor(sd, MT9M111_PAGE_MAP, value, 2);
>        for (address = 0; address < 0xff; address++) {
>                m5602_read_sensor(sd, address, value, 2);
> -               info("register 0x%x contains 0x%x%x",
> -                    address, value[0], value[1]);
> +               pr_info("register 0x%x contains 0x%x%x\n",
> +                       address, value[0], value[1]);
>        }
>
> -       info("Dumping the mt9m111 camera control registers");
> +       pr_info("Dumping the mt9m111 camera control registers\n");
>        value[1] = MT9M111_CAMERA_CONTROL;
>        m5602_write_sensor(sd, MT9M111_PAGE_MAP, value, 2);
>        for (address = 0; address < 0xff; address++) {
>                m5602_read_sensor(sd, address, value, 2);
> -               info("register 0x%x contains 0x%x%x",
> -                    address, value[0], value[1]);
> +               pr_info("register 0x%x contains 0x%x%x\n",
> +                       address, value[0], value[1]);
>        }
>
> -       info("mt9m111 register state dump complete");
> +       pr_info("mt9m111 register state dump complete\n");
>  }
> diff --git a/drivers/media/video/gspca/m5602/m5602_ov7660.c b/drivers/media/video/gspca/m5602/m5602_ov7660.c
> index b12f604..9a14835 100644
> --- a/drivers/media/video/gspca/m5602/m5602_ov7660.c
> +++ b/drivers/media/video/gspca/m5602/m5602_ov7660.c
> @@ -16,6 +16,8 @@
>  *
>  */
>
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "m5602_ov7660.h"
>
>  static int ov7660_get_gain(struct gspca_dev *gspca_dev, __s32 *val);
> @@ -149,7 +151,7 @@ int ov7660_probe(struct sd *sd)
>
>        if (force_sensor) {
>                if (force_sensor == OV7660_SENSOR) {
> -                       info("Forcing an %s sensor", ov7660.name);
> +                       pr_info("Forcing an %s sensor\n", ov7660.name);
>                        goto sensor_found;
>                }
>                /* If we want to force another sensor,
> @@ -180,10 +182,10 @@ int ov7660_probe(struct sd *sd)
>        if (m5602_read_sensor(sd, OV7660_VER, &ver_id, 1))
>                return -ENODEV;
>
> -       info("Sensor reported 0x%x%x", prod_id, ver_id);
> +       pr_info("Sensor reported 0x%x%x\n", prod_id, ver_id);
>
>        if ((prod_id == 0x76) && (ver_id == 0x60)) {
> -               info("Detected a ov7660 sensor");
> +               pr_info("Detected a ov7660 sensor\n");
>                goto sensor_found;
>        }
>        return -ENODEV;
> @@ -457,17 +459,16 @@ static int ov7660_set_vflip(struct gspca_dev *gspca_dev, __s32 val)
>  static void ov7660_dump_registers(struct sd *sd)
>  {
>        int address;
> -       info("Dumping the ov7660 register state");
> +       pr_info("Dumping the ov7660 register state\n");
>        for (address = 0; address < 0xa9; address++) {
>                u8 value;
>                m5602_read_sensor(sd, address, &value, 1);
> -               info("register 0x%x contains 0x%x",
> -                    address, value);
> +               pr_info("register 0x%x contains 0x%x\n", address, value);
>        }
>
> -       info("ov7660 register state dump complete");
> +       pr_info("ov7660 register state dump complete\n");
>
> -       info("Probing for which registers that are read/write");
> +       pr_info("Probing for which registers that are read/write\n");
>        for (address = 0; address < 0xff; address++) {
>                u8 old_value, ctrl_value;
>                u8 test_value[2] = {0xff, 0xff};
> @@ -477,9 +478,9 @@ static void ov7660_dump_registers(struct sd *sd)
>                m5602_read_sensor(sd, address, &ctrl_value, 1);
>
>                if (ctrl_value == test_value[0])
> -                       info("register 0x%x is writeable", address);
> +                       pr_info("register 0x%x is writeable\n", address);
>                else
> -                       info("register 0x%x is read only", address);
> +                       pr_info("register 0x%x is read only\n", address);
>
>                /* Restore original value */
>                m5602_write_sensor(sd, address, &old_value, 1);
> diff --git a/drivers/media/video/gspca/m5602/m5602_ov9650.c b/drivers/media/video/gspca/m5602/m5602_ov9650.c
> index 703d486..2114a8b 100644
> --- a/drivers/media/video/gspca/m5602/m5602_ov9650.c
> +++ b/drivers/media/video/gspca/m5602/m5602_ov9650.c
> @@ -16,6 +16,8 @@
>  *
>  */
>
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "m5602_ov9650.h"
>
>  static int ov9650_set_exposure(struct gspca_dev *gspca_dev, __s32 val);
> @@ -299,7 +301,7 @@ int ov9650_probe(struct sd *sd)
>
>        if (force_sensor) {
>                if (force_sensor == OV9650_SENSOR) {
> -                       info("Forcing an %s sensor", ov9650.name);
> +                       pr_info("Forcing an %s sensor\n", ov9650.name);
>                        goto sensor_found;
>                }
>                /* If we want to force another sensor,
> @@ -330,7 +332,7 @@ int ov9650_probe(struct sd *sd)
>                return -ENODEV;
>
>        if ((prod_id == 0x96) && (ver_id == 0x52)) {
> -               info("Detected an ov9650 sensor");
> +               pr_info("Detected an ov9650 sensor\n");
>                goto sensor_found;
>        }
>        return -ENODEV;
> @@ -850,17 +852,16 @@ static int ov9650_set_auto_gain(struct gspca_dev *gspca_dev, __s32 val)
>  static void ov9650_dump_registers(struct sd *sd)
>  {
>        int address;
> -       info("Dumping the ov9650 register state");
> +       pr_info("Dumping the ov9650 register state\n");
>        for (address = 0; address < 0xa9; address++) {
>                u8 value;
>                m5602_read_sensor(sd, address, &value, 1);
> -               info("register 0x%x contains 0x%x",
> -                    address, value);
> +               pr_info("register 0x%x contains 0x%x\n", address, value);
>        }
>
> -       info("ov9650 register state dump complete");
> +       pr_info("ov9650 register state dump complete\n");
>
> -       info("Probing for which registers that are read/write");
> +       pr_info("Probing for which registers that are read/write\n");
>        for (address = 0; address < 0xff; address++) {
>                u8 old_value, ctrl_value;
>                u8 test_value[2] = {0xff, 0xff};
> @@ -870,9 +871,9 @@ static void ov9650_dump_registers(struct sd *sd)
>                m5602_read_sensor(sd, address, &ctrl_value, 1);
>
>                if (ctrl_value == test_value[0])
> -                       info("register 0x%x is writeable", address);
> +                       pr_info("register 0x%x is writeable\n", address);
>                else
> -                       info("register 0x%x is read only", address);
> +                       pr_info("register 0x%x is read only\n", address);
>
>                /* Restore original value */
>                m5602_write_sensor(sd, address, &old_value, 1);
> diff --git a/drivers/media/video/gspca/m5602/m5602_po1030.c b/drivers/media/video/gspca/m5602/m5602_po1030.c
> index 1febd34..b877169 100644
> --- a/drivers/media/video/gspca/m5602/m5602_po1030.c
> +++ b/drivers/media/video/gspca/m5602/m5602_po1030.c
> @@ -16,6 +16,8 @@
>  *
>  */
>
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "m5602_po1030.h"
>
>  static int po1030_get_exposure(struct gspca_dev *gspca_dev, __s32 *val);
> @@ -197,7 +199,7 @@ int po1030_probe(struct sd *sd)
>
>        if (force_sensor) {
>                if (force_sensor == PO1030_SENSOR) {
> -                       info("Forcing a %s sensor", po1030.name);
> +                       pr_info("Forcing a %s sensor\n", po1030.name);
>                        goto sensor_found;
>                }
>                /* If we want to force another sensor, don't try to probe this
> @@ -221,7 +223,7 @@ int po1030_probe(struct sd *sd)
>                return -ENODEV;
>
>        if (dev_id_h == 0x30) {
> -               info("Detected a po1030 sensor");
> +               pr_info("Detected a po1030 sensor\n");
>                goto sensor_found;
>        }
>        return -ENODEV;
> @@ -267,7 +269,7 @@ int po1030_init(struct sd *sd)
>                        break;
>
>                default:
> -                       info("Invalid stream command, exiting init");
> +                       pr_info("Invalid stream command, exiting init\n");
>                        return -EINVAL;
>                }
>        }
> @@ -733,16 +735,15 @@ static void po1030_dump_registers(struct sd *sd)
>        int address;
>        u8 value = 0;
>
> -       info("Dumping the po1030 sensor core registers");
> +       pr_info("Dumping the po1030 sensor core registers\n");
>        for (address = 0; address < 0x7f; address++) {
>                m5602_read_sensor(sd, address, &value, 1);
> -               info("register 0x%x contains 0x%x",
> -                    address, value);
> +               pr_info("register 0x%x contains 0x%x\n", address, value);
>        }
>
> -       info("po1030 register state dump complete");
> +       pr_info("po1030 register state dump complete\n");
>
> -       info("Probing for which registers that are read/write");
> +       pr_info("Probing for which registers that are read/write\n");
>        for (address = 0; address < 0xff; address++) {
>                u8 old_value, ctrl_value;
>                u8 test_value[2] = {0xff, 0xff};
> @@ -752,9 +753,9 @@ static void po1030_dump_registers(struct sd *sd)
>                m5602_read_sensor(sd, address, &ctrl_value, 1);
>
>                if (ctrl_value == test_value[0])
> -                       info("register 0x%x is writeable", address);
> +                       pr_info("register 0x%x is writeable\n", address);
>                else
> -                       info("register 0x%x is read only", address);
> +                       pr_info("register 0x%x is read only\n", address);
>
>                /* Restore original value */
>                m5602_write_sensor(sd, address, &old_value, 1);
> diff --git a/drivers/media/video/gspca/m5602/m5602_s5k4aa.c b/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
> index d27280b..cc8ec3f 100644
> --- a/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
> +++ b/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
> @@ -16,6 +16,8 @@
>  *
>  */
>
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "m5602_s5k4aa.h"
>
>  static int s5k4aa_get_exposure(struct gspca_dev *gspca_dev, __s32 *val);
> @@ -240,7 +242,7 @@ int s5k4aa_probe(struct sd *sd)
>
>        if (force_sensor) {
>                if (force_sensor == S5K4AA_SENSOR) {
> -                       info("Forcing a %s sensor", s5k4aa.name);
> +                       pr_info("Forcing a %s sensor\n", s5k4aa.name);
>                        goto sensor_found;
>                }
>                /* If we want to force another sensor, don't try to probe this
> @@ -276,7 +278,7 @@ int s5k4aa_probe(struct sd *sd)
>                                                  data, 2);
>                        break;
>                default:
> -                       info("Invalid stream command, exiting init");
> +                       pr_info("Invalid stream command, exiting init\n");
>                        return -EINVAL;
>                }
>        }
> @@ -292,7 +294,7 @@ int s5k4aa_probe(struct sd *sd)
>        if (memcmp(prod_id, expected_prod_id, sizeof(prod_id)))
>                return -ENODEV;
>        else
> -               info("Detected a s5k4aa sensor");
> +               pr_info("Detected a s5k4aa sensor\n");
>
>  sensor_found:
>        sensor_settings = kmalloc(
> @@ -347,7 +349,7 @@ int s5k4aa_start(struct sd *sd)
>                        break;
>
>                        default:
> -                               err("Invalid stream command, exiting init");
> +                               pr_err("Invalid stream command, exiting init\n");
>                                return -EINVAL;
>                        }
>                }
> @@ -383,7 +385,7 @@ int s5k4aa_start(struct sd *sd)
>                        break;
>
>                        default:
> -                               err("Invalid stream command, exiting init");
> +                               pr_err("Invalid stream command, exiting init\n");
>                                return -EINVAL;
>                        }
>                }
> @@ -447,7 +449,7 @@ int s5k4aa_init(struct sd *sd)
>                                init_s5k4aa[i][1], data, 2);
>                        break;
>                default:
> -                       info("Invalid stream command, exiting init");
> +                       pr_info("Invalid stream command, exiting init\n");
>                        return -EINVAL;
>                }
>        }
> @@ -686,20 +688,21 @@ static void s5k4aa_dump_registers(struct sd *sd)
>        m5602_read_sensor(sd, S5K4AA_PAGE_MAP, &old_page, 1);
>        for (page = 0; page < 16; page++) {
>                m5602_write_sensor(sd, S5K4AA_PAGE_MAP, &page, 1);
> -               info("Dumping the s5k4aa register state for page 0x%x", page);
> +               pr_info("Dumping the s5k4aa register state for page 0x%x\n",
> +                       page);
>                for (address = 0; address <= 0xff; address++) {
>                        u8 value = 0;
>                        m5602_read_sensor(sd, address, &value, 1);
> -                       info("register 0x%x contains 0x%x",
> -                            address, value);
> +                       pr_info("register 0x%x contains 0x%x\n",
> +                               address, value);
>                }
>        }
> -       info("s5k4aa register state dump complete");
> +       pr_info("s5k4aa register state dump complete\n");
>
>        for (page = 0; page < 16; page++) {
>                m5602_write_sensor(sd, S5K4AA_PAGE_MAP, &page, 1);
> -               info("Probing for which registers that are "
> -                    "read/write for page 0x%x", page);
> +               pr_info("Probing for which registers that are read/write for page 0x%x\n",
> +                       page);
>                for (address = 0; address <= 0xff; address++) {
>                        u8 old_value, ctrl_value, test_value = 0xff;
>
> @@ -708,14 +711,16 @@ static void s5k4aa_dump_registers(struct sd *sd)
>                        m5602_read_sensor(sd, address, &ctrl_value, 1);
>
>                        if (ctrl_value == test_value)
> -                               info("register 0x%x is writeable", address);
> +                               pr_info("register 0x%x is writeable\n",
> +                                       address);
>                        else
> -                               info("register 0x%x is read only", address);
> +                               pr_info("register 0x%x is read only\n",
> +                                       address);
>
>                        /* Restore original value */
>                        m5602_write_sensor(sd, address, &old_value, 1);
>                }
>        }
> -       info("Read/write register probing complete");
> +       pr_info("Read/write register probing complete\n");
>        m5602_write_sensor(sd, S5K4AA_PAGE_MAP, &old_page, 1);
>  }
> diff --git a/drivers/media/video/gspca/m5602/m5602_s5k83a.c b/drivers/media/video/gspca/m5602/m5602_s5k83a.c
> index fbd9154..1de743a 100644
> --- a/drivers/media/video/gspca/m5602/m5602_s5k83a.c
> +++ b/drivers/media/video/gspca/m5602/m5602_s5k83a.c
> @@ -16,6 +16,8 @@
>  *
>  */
>
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/kthread.h>
>  #include "m5602_s5k83a.h"
>
> @@ -135,7 +137,7 @@ int s5k83a_probe(struct sd *sd)
>
>        if (force_sensor) {
>                if (force_sensor == S5K83A_SENSOR) {
> -                       info("Forcing a %s sensor", s5k83a.name);
> +                       pr_info("Forcing a %s sensor\n", s5k83a.name);
>                        goto sensor_found;
>                }
>                /* If we want to force another sensor, don't try to probe this
> @@ -168,7 +170,7 @@ int s5k83a_probe(struct sd *sd)
>        if ((prod_id == 0xff) || (ver_id == 0xff))
>                return -ENODEV;
>        else
> -               info("Detected a s5k83a sensor");
> +               pr_info("Detected a s5k83a sensor\n");
>
>  sensor_found:
>        sens_priv = kmalloc(
> @@ -227,7 +229,7 @@ int s5k83a_init(struct sd *sd)
>                                init_s5k83a[i][1], data, 2);
>                        break;
>                default:
> -                       info("Invalid stream command, exiting init");
> +                       pr_info("Invalid stream command, exiting init\n");
>                        return -EINVAL;
>                }
>        }
> @@ -273,7 +275,7 @@ static int rotation_thread_function(void *data)
>                s5k83a_get_rotation(sd, &reg);
>                if (previous_rotation != reg) {
>                        previous_rotation = reg;
> -                       info("Camera was flipped");
> +                       pr_info("Camera was flipped\n");
>
>                        s5k83a_get_vflip((struct gspca_dev *) sd, &vflip);
>                        s5k83a_get_hflip((struct gspca_dev *) sd, &hflip);
> @@ -566,20 +568,20 @@ static void s5k83a_dump_registers(struct sd *sd)
>
>        for (page = 0; page < 16; page++) {
>                m5602_write_sensor(sd, S5K83A_PAGE_MAP, &page, 1);
> -               info("Dumping the s5k83a register state for page 0x%x", page);
> +               pr_info("Dumping the s5k83a register state for page 0x%x\n",
> +                       page);
>                for (address = 0; address <= 0xff; address++) {
>                        u8 val = 0;
>                        m5602_read_sensor(sd, address, &val, 1);
> -                       info("register 0x%x contains 0x%x",
> -                            address, val);
> +                       pr_info("register 0x%x contains 0x%x\n", address, val);
>                }
>        }
> -       info("s5k83a register state dump complete");
> +       pr_info("s5k83a register state dump complete\n");
>
>        for (page = 0; page < 16; page++) {
>                m5602_write_sensor(sd, S5K83A_PAGE_MAP, &page, 1);
> -               info("Probing for which registers that are read/write "
> -                               "for page 0x%x", page);
> +               pr_info("Probing for which registers that are read/write for page 0x%x\n",
> +                       page);
>                for (address = 0; address <= 0xff; address++) {
>                        u8 old_val, ctrl_val, test_val = 0xff;
>
> @@ -588,14 +590,16 @@ static void s5k83a_dump_registers(struct sd *sd)
>                        m5602_read_sensor(sd, address, &ctrl_val, 1);
>
>                        if (ctrl_val == test_val)
> -                               info("register 0x%x is writeable", address);
> +                               pr_info("register 0x%x is writeable\n",
> +                                       address);
>                        else
> -                               info("register 0x%x is read only", address);
> +                               pr_info("register 0x%x is read only\n",
> +                                       address);
>
>                        /* Restore original val */
>                        m5602_write_sensor(sd, address, &old_val, 1);
>                }
>        }
> -       info("Read/write register probing complete");
> +       pr_info("Read/write register probing complete\n");
>        m5602_write_sensor(sd, S5K83A_PAGE_MAP, &old_page, 1);
>  }
> --
> 1.7.6.405.gc1be0
>
>

Looks good.

Acked-by: Erik Andrén <erik.andren@gmail.com>
