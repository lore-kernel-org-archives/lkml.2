Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab2FMHDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:03:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63109 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2FMHDe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:03:34 -0400
Date: Wed, 13 Jun 2012 09:03:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] irq/core changes for v3.5
In-Reply-To: <CA+55aFxC0436vCDwX8nUnKNa3ZZi=ZhL0w6eMk0hM3oKTz4LJw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1206130857070.17854@axis700.grange>
References: <20120522032554.GA11358@gmail.com> <Pine.LNX.4.64.1206121201130.6800@axis700.grange>
 <alpine.LFD.2.02.1206121639420.3086@ionos>
 <CA+55aFxNy2-DnWVDUiOuF+NncRBUC=frZN+CTLsJ+o2ofXtZYQ@mail.gmail.com>
 <alpine.LFD.2.02.1206121732230.3086@ionos>
 <CA+55aFxC0436vCDwX8nUnKNa3ZZi=ZhL0w6eMk0hM3oKTz4LJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:EgDsqSgARbNn+ADdXMdZEKiXAtZC+Z6+X7FMHesGIrk
 NwzqCJu/M4bjMHUENkkkRhHUfOKgkv8ZCp+Cgq0s0KqFRn4yeC
 JxiipGQfynGNveFVTsBqPSvUNgxCiBwgI2PYfH3SP5HdK0k2ti
 QQpGqOOWUgGx6Qi6TzEbzVWGn+O3fci0LmInaml+gbFM7KS1Cj
 u+Q1IPTGsQqNEHxGPuMyYEGzvA9JqtRcdptwqfavUN9S3hslei
 qm5UG4urUE0qlr3BgOePxli9MJ7oHvtvlbOM2Xh30X/KNBbl/y
 1mzGjFFjRIgix3eYvw9oDrkTnnXwfsGkjoiP9n/hsenKUB0k0I
 uRMzR8H8nyR0jmzb5OZ8mwSzWf6pL/PlliDP/QaH3zh9pUX3D8
 kPJdBm7RQvUWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

On Wed, 13 Jun 2012, Linus Torvalds wrote:

> On Tue, Jun 12, 2012 at 7:47 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > So now we have the choice of:
> >
> >   - Leaving the current check and regress 90+ drivers
> >
> >   - Leaving the current check and fix 90+ broken drivers
> >
> >   - Reverting it and end up with no protection at all
> >
> >   - Forcing the flag and risking the wreckage of two oddball drivers
> >     _IF_ they ever show up on a PC platform.
> 
> So I'd really prefer #2.
> 
> I'd rather have a nice sane generic irq layer that really makes it an
> *error* to do stupid things that make no sense, and then fix the
> drivers that do them.

To make this simpler I'm attaching below a list of (I think) all 
occurrences of the invalid request_threaded_irq() uses.

[snip]

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

drivers/regulator/wm831x-dcdc.c
ret = request_threaded_irq(irq, NULL, wm831x_dcdc_uv_irq, IRQF_TRIGGER_RISING, dcdc->name, dcdc);
ret = request_threaded_irq(irq, NULL, wm831x_dcdc_oc_irq, IRQF_TRIGGER_RISING, dcdc->name, dcdc);
ret = request_threaded_irq(irq, NULL, wm831x_dcdc_uv_irq, IRQF_TRIGGER_RISING, dcdc->name, dcdc);
ret = request_threaded_irq(irq, NULL, wm831x_dcdc_uv_irq, IRQF_TRIGGER_RISING, dcdc->name, dcdc);

drivers/regulator/wm831x-isink.c
ret = request_threaded_irq(irq, NULL, wm831x_isink_irq, IRQF_TRIGGER_RISING, isink->name, isink);

drivers/regulator/wm831x-ldo.c
ret = request_threaded_irq(irq, NULL, wm831x_ldo_uv_irq, IRQF_TRIGGER_RISING, ldo->name, ldo);
ret = request_threaded_irq(irq, NULL, wm831x_ldo_uv_irq, IRQF_TRIGGER_RISING, ldo->name, ldo);

drivers/gpio/gpio-ab8500.c
ret = request_threaded_irq(irq_to_rising(irq), NULL, handle_rising, IRQF_TRIGGER_RISING, "ab8500-gpio-r", ab8500_gpio);

drivers/gpio/gpio-sx150x.c
err = request_threaded_irq(irq_summary, NULL, sx150x_irq_thread_fn, IRQF_SHARED | IRQF_TRIGGER_FALLING, chip->irq_chip.name, chip);

drivers/rtc/rtc-wm831x.c
ret = request_threaded_irq(alm_irq, NULL, wm831x_alm_irq, IRQF_TRIGGER_RISING, "RTC alarm", wm831x_rtc);

drivers/rtc/rtc-max8998.c
ret = request_threaded_irq(info->irq, NULL, max8998_rtc_alarm_irq, 0, "rtc-alarm0", info);

drivers/rtc/rtc-twl.c
ret = request_threaded_irq(irq, NULL, twl_rtc_interrupt, IRQF_TRIGGER_RISING, dev_name(&rtc->dev), rtc);

drivers/rtc/rtc-ab8500.c
err = request_threaded_irq(irq, NULL, rtc_alarm_handler, IRQF_NO_SUSPEND, "ab8500-rtc", rtc);

drivers/rtc/rtc-isl1208.c
rc = request_threaded_irq(client->irq, NULL, isl1208_rtc_interrupt, IRQF_SHARED, isl1208_driver.driver.name, client);

drivers/mmc/core/cd-gpio.c
ret = request_threaded_irq(irq, NULL, mmc_cd_gpio_irqt, IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING, cd->label, host);

drivers/mmc/host/sdhci-s3c.c
request_threaded_irq(sc->ext_cd_irq, NULL, sdhci_s3c_gpio_card_detect_thread, IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING, dev_name(dev), sc) == 0) { int status = gpio_get_value(sc->ext_cd_gpio);

drivers/mmc/host/of_mmc_spi.c
return request_threaded_irq(oms->detect_irq, NULL, irqhandler, 0, dev_name(dev), mmc);

drivers/net/can/mcp251x.c
ret = request_threaded_irq(spi->irq, NULL, mcp251x_can_ist, pdata->irq_flags ? pdata->irq_flags : IRQF_TRIGGER_FALLING, DEVICE_NAME, priv);

drivers/misc/mei/main.c
err = request_threaded_irq(pdev->irq, NULL, mei_interrupt_thread_handler, 0, mei_driver_name, dev);
err = request_threaded_irq(pdev->irq, NULL, mei_interrupt_thread_handler, 0, mei_driver_name, dev);

drivers/input/misc/ad714x.c
error = request_threaded_irq(ad714x->irq, NULL, ad714x_interrupt_thread, plat_data->irqflags ? plat_data->irqflags : IRQF_TRIGGER_FALLING, "ad714x_captouch", ad714x);

drivers/input/misc/wm831x-on.c
ret = request_threaded_irq(irq, NULL, wm831x_on_irq, IRQF_TRIGGER_RISING, "wm831x_on", wm831x_on);

drivers/input/misc/twl6040-vibra.c
ret = request_threaded_irq(info->irq, NULL, twl6040_vib_irq_handler, 0, "twl6040_irq_vib", info);

drivers/input/misc/twl4030-pwrbutton.c
err = request_threaded_irq(irq, NULL, powerbutton_irq, IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING, "twl4030_pwrbutton", pwr);

drivers/input/misc/dm355evm_keys.c
status = request_threaded_irq(keys->irq, NULL, dm355evm_keys_irq, IRQF_TRIGGER_FALLING, dev_name(&pdev->dev), keys);

drivers/input/keyboard/twl4030_keypad.c
error = request_threaded_irq(kp->irq, NULL, do_kp_irq, 0, pdev->name, kp);

drivers/input/keyboard/mpr121_touchkey.c
error = request_threaded_irq(client->irq, NULL, mpr_touchkey_interrupt, IRQF_TRIGGER_FALLING, client->dev.driver->name, mpr121);

drivers/input/keyboard/mcs_touchkey.c
error = request_threaded_irq(client->irq, NULL, mcs_touchkey_interrupt, IRQF_TRIGGER_FALLING, client->dev.driver->name, data);

drivers/input/keyboard/tnetv107x-keypad.c
error = request_threaded_irq(kp->irq_press, NULL, keypad_irq, 0, dev_name(dev), kp);
error = request_threaded_irq(kp->irq_release, NULL, keypad_irq, 0, dev_name(dev), kp);

drivers/input/keyboard/tc3589x-keypad.c
error = request_threaded_irq(irq, NULL, tc3589x_keypad_irq, plat->irqtype, "tc3589x-keypad", keypad);

drivers/input/keyboard/tca6416-keypad.c
error = request_threaded_irq(chip->irqnum, NULL, tca6416_keys_isr, IRQF_TRIGGER_FALLING, "tca6416-keypad", chip);

drivers/input/keyboard/tca8418_keypad.c
error = request_threaded_irq(client->irq, NULL, tca8418_irq_handler, IRQF_TRIGGER_FALLING, client->name, keypad_data);

drivers/input/keyboard/qt1070.c
err = request_threaded_irq(client->irq, NULL, qt1070_interrupt, IRQF_TRIGGER_NONE, client->dev.driver->name, data);

drivers/input/touchscreen/tnetv107x-ts.c
error = request_threaded_irq(ts->tsc_irq, NULL, tsc_irq, 0, dev_name(dev), ts);

drivers/input/touchscreen/bu21013_ts.c
error = request_threaded_irq(pdata->irq, NULL, bu21013_gpio_irq, IRQF_TRIGGER_FALLING | IRQF_SHARED, DRIVER_TP, bu21013_data);

drivers/input/touchscreen/intel-mid-touch.c
err = request_threaded_irq(tsdev->irq, NULL, mrstouch_pendet_irq, 0, "mrstouch", tsdev);

drivers/input/touchscreen/tsc2005.c
error = request_threaded_irq(spi->irq, NULL, tsc2005_irq_thread, IRQF_TRIGGER_RISING, "tsc2005", ts);

drivers/input/touchscreen/atmel_mxt_ts.c
error = request_threaded_irq(client->irq, NULL, mxt_interrupt, pdata->irqflags, client->dev.driver->name, data);

drivers/input/touchscreen/cy8ctmg110_ts.c
err = request_threaded_irq(client->irq, NULL, cy8ctmg110_irq_thread, IRQF_TRIGGER_RISING, "touch_reset_key", ts);

drivers/input/touchscreen/ad7879.c
err = request_threaded_irq(ts->irq, NULL, ad7879_irq, IRQF_TRIGGER_FALLING, dev_name(dev), ts);

drivers/input/touchscreen/pixcir_i2c_ts.c
error = request_threaded_irq(client->irq, NULL, pixcir_ts_isr, IRQF_TRIGGER_FALLING, client->name, tsdata);

drivers/input/joystick/as5011.c
error = request_threaded_irq(as5011->button_irq, NULL, as5011_button_interrupt, IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING, "as5011_button", as5011);
error = request_threaded_irq(as5011->axis_irq, NULL, as5011_axis_interrupt, plat_data->axis_irqflags, "as5011_joystick", as5011);

drivers/nfc/pn544.c
r = request_threaded_irq(client->irq, NULL, pn544_irq_thread_fn, IRQF_TRIGGER_RISING, PN544_DRIVER_NAME, info);

drivers/nfc/pn544_hci.c
r = request_threaded_irq(client->irq, NULL, pn544_hci_irq_thread_fn, IRQF_TRIGGER_RISING, PN544_HCI_DRIVER_NAME, info);

drivers/power/twl4030_charger.c
ret = request_threaded_irq(bci->irq_chg, NULL, twl4030_charger_interrupt, 0, pdev->name, bci);
ret = request_threaded_irq(bci->irq_bci, NULL, twl4030_bci_interrupt, 0, pdev->name, bci);

drivers/power/ab8500_charger.c
ret = request_threaded_irq(irq, NULL, ab8500_charger_irq[i].isr, IRQF_SHARED | IRQF_NO_SUSPEND, ab8500_charger_irq[i].name, di);

drivers/power/wm831x_power.c
ret = request_threaded_irq(irq, NULL, wm831x_syslo_irq, IRQF_TRIGGER_RISING, "System power low", power);
ret = request_threaded_irq(irq, NULL, wm831x_pwr_src_irq, IRQF_TRIGGER_RISING, "Power source", power);
ret = request_threaded_irq(irq, NULL, wm831x_bat_irq, IRQF_TRIGGER_RISING, wm831x_bat_irqs[i], power);

drivers/power/lp8727_charger.c
return request_threaded_irq(pchg->client->irq, NULL, lp8727_isr_func, IRQF_TRIGGER_FALLING, "lp8727_irq", pchg);

drivers/power/max8903_charger.c
ret = request_threaded_irq(gpio_to_irq(pdata->dok), NULL, max8903_dcin, IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING, "MAX8903 DC IN", data);
ret = request_threaded_irq(gpio_to_irq(pdata->uok), NULL, max8903_usbin, IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING, "MAX8903 USB IN", data);
ret = request_threaded_irq(gpio_to_irq(pdata->flt), NULL, max8903_fault, IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING, "MAX8903 Fault", data);

drivers/power/max17042_battery.c
ret = request_threaded_irq(client->irq, NULL, max17042_thread_handler, IRQF_TRIGGER_FALLING, chip->battery.name, chip);

drivers/power/smb347-charger.c
ret = request_threaded_irq(irq, NULL, smb347_interrupt, IRQF_TRIGGER_FALLING, client->name, smb);

drivers/power/ab8500_btemp.c
ret = request_threaded_irq(irq, NULL, ab8500_btemp_irq[i].isr, IRQF_SHARED | IRQF_NO_SUSPEND, ab8500_btemp_irq[i].name, di);

drivers/power/ab8500_fg.c
ret = request_threaded_irq(irq, NULL, ab8500_fg_irq[i].isr, IRQF_SHARED | IRQF_NO_SUSPEND, ab8500_fg_irq[i].name, di);

drivers/base/regmap/regmap-irq.c
ret = request_threaded_irq(irq, NULL, regmap_irq_thread, irq_flags, chip->name, d);

drivers/staging/cptm1217/clearpad_tm1217.c
retval = request_threaded_irq(client->irq, NULL, cp_tm1217_sample_thread, IRQF_TRIGGER_FALLING, "cp_tm1217_touch", ts);

drivers/staging/iio/accel/sca3000_core.c
ret = request_threaded_irq(spi->irq, NULL, &sca3000_event_handler, IRQF_TRIGGER_FALLING, "sca3000", indio_dev);

drivers/staging/iio/adc/adt7410.c
ret = request_threaded_irq(client->irq, NULL, &adt7410_event_handler, IRQF_TRIGGER_LOW, id->name, indio_dev);
ret = request_threaded_irq(adt7410_platform_data[0], NULL, &adt7410_event_handler, adt7410_platform_data[1], id->name, indio_dev);

drivers/staging/iio/adc/ad7816.c
ret = request_threaded_irq(spi_dev->irq, NULL, &ad7816_event_handler, IRQF_TRIGGER_LOW, indio_dev->name, indio_dev);

drivers/staging/iio/adc/adt7310.c
ret = request_threaded_irq(spi_dev->irq, NULL, &adt7310_event_handler, irq_flags, indio_dev->name, indio_dev);
ret = request_threaded_irq(adt7310_platform_data[0], NULL, &adt7310_event_handler, adt7310_platform_data[1], indio_dev->name, indio_dev);

drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
retval = request_threaded_irq(platformdata->irq_number, NULL, synaptics_rmi4_irq, platformdata->irq_type, DRIVER_NAME, rmi4_data);

drivers/media/radio/si470x/radio-si470x-i2c.c
retval = request_threaded_irq(client->irq, NULL, si470x_i2c_interrupt, IRQF_TRIGGER_FALLING, DRIVER_NAME, radio);

drivers/extcon/extcon-max8997.c
ret = request_threaded_irq(pdata->irq_base + muic_irq->irq, NULL, max8997_muic_irq_handler, 0, muic_irq->name, info);

drivers/mfd/tps65912-irq.c
ret = request_threaded_irq(irq, NULL, tps65912_irq, flags, "tps65912", tps65912);

drivers/mfd/wm831x-auxadc.c
ret = request_threaded_irq(wm831x_irq(wm831x, WM831X_IRQ_AUXADC_DATA), NULL, wm831x_auxadc_irq, 0, "auxadc", wm831x);

drivers/mfd/twl4030-irq.c
status = request_threaded_irq(irq, NULL, handle_twl4030_sih, 0, agent->irq_name ?: sih->name, NULL);

drivers/mfd/ab8500-gpadc.c
ret = request_threaded_irq(gpadc->irq, NULL, ab8500_bm_gpswadcconvend_handler, IRQF_NO_SUSPEND | IRQF_SHARED, "ab8500-gpadc", gpadc);

drivers/mfd/htc-i2cpld.c
ret = request_threaded_irq(htcpld->chained_irq, NULL, htcpld_handler, flags, pdev->name, htcpld);

drivers/mfd/wm8350-core.c
ret = request_threaded_irq(wm8350->irq_base + WM8350_IRQ_AUXADC_DATARDY, NULL, wm8350_auxadc_irq, 0, "auxadc", wm8350);

drivers/mfd/twl4030-madc.c
ret = request_threaded_irq(platform_get_irq(pdev, 0), NULL, twl4030_madc_threaded_irq_handler, IRQF_TRIGGER_RISING, "twl4030_madc", madc);

drivers/mfd/88pm860x-core.c
ret = request_threaded_irq(chip->core_irq, NULL, pm860x_irq, flags, "88pm860x", chip);

drivers/mfd/twl6040-core.c
ret = request_threaded_irq(twl6040->irq_base + TWL6040_IRQ_READY, NULL, twl6040_naudint_handler, 0, "twl6040_irq_ready", twl6040);

drivers/mfd/tps65910-irq.c
ret = request_threaded_irq(irq, NULL, tps65910_irq, flags, "tps65910", tps65910);

drivers/mfd/ti-ssp.c
error = request_threaded_irq(ssp->irq, NULL, ti_ssp_interrupt, 0, dev_name(dev), ssp);

drivers/mfd/max8925-core.c
ret = request_threaded_irq(irq, NULL, max8925_irq, flags, "max8925", chip);
ret = request_threaded_irq(chip->tsc_irq, NULL, max8925_tsc_irq, flags, "max8925-tsc", chip);

drivers/mfd/wm8350-irq.c
ret = request_threaded_irq(irq, NULL, wm8350_irq, flags, "wm8350", wm8350);

drivers/usb/otg/twl4030-usb.c
status = request_threaded_irq(twl->irq, NULL, twl4030_usb_irq, IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING, "twl4030_usb", twl);

drivers/usb/otg/ab8500-usb.c
err = request_threaded_irq(ab->irq_num_id_rise, NULL, ab8500_usb_v1x_common_irq, IRQF_NO_SUSPEND | IRQF_SHARED, "usb-id-rise", ab);
err = request_threaded_irq(ab->irq_num_id_fall, NULL, ab8500_usb_v1x_common_irq, IRQF_NO_SUSPEND | IRQF_SHARED, "usb-id-fall", ab);
err = request_threaded_irq(ab->irq_num_vbus_rise, NULL, ab8500_usb_v1x_common_irq, IRQF_NO_SUSPEND | IRQF_SHARED, "usb-vbus-rise", ab);
err = request_threaded_irq(ab->irq_num_vbus_fall, NULL, ab8500_usb_v1x_vbus_fall_irq, IRQF_NO_SUSPEND | IRQF_SHARED, "usb-vbus-fall", ab);
err = request_threaded_irq(ab->irq_num_link_status, NULL, ab8500_usb_v20_irq, IRQF_NO_SUSPEND | IRQF_SHARED, "usb-link-status", ab);

drivers/platform/x86/intel_mid_powerbtn.c
error = request_threaded_irq(irq, NULL, mfld_pb_isr, IRQF_NO_SUSPEND, DRIVER_NAME, input);

sound/soc/codecs/wm8996.c
ret = request_threaded_irq(i2c->irq, NULL, wm8996_edge_irq, irq_flags, "wm8996", codec);

sound/soc/codecs/wm5100.c
ret = request_threaded_irq(i2c->irq, NULL, wm5100_edge_irq, irq_flags, "wm5100", wm5100);

sound/soc/codecs/wm8994.c
ret = request_threaded_irq(wm8994->micdet_irq, NULL, wm8994_mic_irq, IRQF_TRIGGER_RISING, "Mic1 detect", wm8994);
ret = request_threaded_irq(wm8994->micdet_irq, NULL, wm8958_mic_irq, IRQF_TRIGGER_RISING, "Mic detect", wm8994);

sound/soc/codecs/twl6040.c
ret = request_threaded_irq(priv->plug_irq, NULL, twl6040_audio_handler, 0, "twl6040_irq_plug", codec);

sound/soc/codecs/max98095.c
ret = request_threaded_irq(client->irq, NULL, max98095_report_jack, IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING, "max98095", codec);

./include/linux/mfd/wm8994/core.h
return request_threaded_irq(regmap_irq_get_virq(wm8994->irq_data, irq), NULL, handler, IRQF_TRIGGER_RISING, name, data);

./include/linux/mfd/wm8350/core.h
return request_threaded_irq(irq + wm8350->irq_base, NULL, handler, flags, name, data);
