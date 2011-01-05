Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab1AEAkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 19:40:22 -0500
Received: from ns2.cypress.com ([157.95.67.5]:47372 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab1AEAkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 19:40:20 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Subject: RE: [v3 2/3] 2/3 i2c: Cypress TTSP G3 MTDEV I2C Device Driver
Date: Tue, 4 Jan 2011 16:37:28 -0800
Message-ID: <FB9C2CB29A07AB45B575A4E8D2AABC09014002D4@labamba.mis.cypress.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [v3 2/3] 2/3 i2c: Cypress TTSP G3 MTDEV I2C Device Driver
Thread-Index: AcursMd0f5bUkLLRRYmfwlu8LvtAggAv8fZg
References: <Kevin McNeely <kev@cypress.com> <1293650268-1561-2-git-send-email-kev@cypress.com> <1294105556.2570.14.camel@hongdev>
From: "Kevin McNeely" <Kevin.McNeely@cypress.com>
To: "Hong Liu" <hong.liu@intel.com>
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "David Brown" <davidb@codeaurora.org>,
        "Trilok Soni" <tsoni@codeaurora.org>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Eric Miao" <eric.y.miao@gmail.com>,
        "Mike Frysinger" <vapier@gentoo.org>,
        "Henrik Rydberg" <rydberg@euromail.se>,
        "Alan Cox" <alan@linux.intel.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 Jan 2011 00:38:26.0765 (UTC) FILETIME=[DDCC27D0:01CBAC70]
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p050eVs4014440

Hello Hong,

The pointers will be fixed in v4.

Thank you,
Kevin

> -----Original Message-----
> From: Hong Liu [mailto:hong.liu@intel.com]
> Sent: Monday, January 03, 2011 5:46 PM
> To: Kevin McNeely
> Cc: Dmitry Torokhov; David Brown; Trilok Soni; Samuel Ortiz; Eric Miao;
> Mike Frysinger; Henrik Rydberg; Alan Cox; linux-input@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [v3 2/3] 2/3 i2c: Cypress TTSP G3 MTDEV I2C Device Driver
> 
> On Thu, 2010-12-30 at 03:17 +0800, Kevin McNeely wrote:
> [...]
> > +
> > +/* registered in driver struct */
> > +static int __devexit cyttsp_i2c_remove(struct i2c_client *client)
> > +{
> > +	struct cyttsp_i2c *ts;
> > +
> > +	ts = i2c_get_clientdata(client);
> > +	cyttsp_core_release(ts->ttsp_client);
> > +	kfree(ts);
> > +	return 0;
> > +}
> > +
> > +#ifdef CONFIG_PM
> > +static int cyttsp_i2c_suspend(struct i2c_client *client,
> pm_message_t message)
> > +{
> > +	return cyttsp_suspend(dev_get_drvdata(&client->dev));
> > +}
> > +
> > +static int cyttsp_i2c_resume(struct i2c_client *client)
> > +{
> > +	return cyttsp_resume(dev_get_drvdata(&client->dev));
> > +}
> > +#endif
> 
> I think what we get here is a pointer to cyttsp_i2c, and we need to
> pass
> cyttsp_i2c->ttsp_client to cyttsp_suspend/resume.
> 
> Thanks,
> Hong
> 
> > +
> > +static const struct i2c_device_id cyttsp_i2c_id[] = {
> > +	{ CY_I2C_NAME, 0 },  { }
> > +};
> > +
> > +static struct i2c_driver cyttsp_i2c_driver = {
> > +	.driver = {
> > +		.name = CY_I2C_NAME,
> > +		.owner = THIS_MODULE,
> > +	},
> > +	.probe = cyttsp_i2c_probe,
> > +	.remove = __devexit_p(cyttsp_i2c_remove),
> > +	.id_table = cyttsp_i2c_id,
> > +#ifdef CONFIG_PM
> > +	.suspend = cyttsp_i2c_suspend,
> > +	.resume = cyttsp_i2c_resume,
> > +#endif
> > +};
> > +
> > +static int __init cyttsp_i2c_init(void)
> > +{
> > +	return i2c_add_driver(&cyttsp_i2c_driver);
> > +}
> > +
> > +static void __exit cyttsp_i2c_exit(void)
> > +{
> > +	return i2c_del_driver(&cyttsp_i2c_driver);
> > +}
> > +
> > +module_init(cyttsp_i2c_init);
> > +module_exit(cyttsp_i2c_exit);
> > +
> > +MODULE_ALIAS("i2c:cyttsp");
> > +MODULE_LICENSE("GPL");
> > +MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard Product (TTSP) I2C
> driver");
> > +MODULE_AUTHOR("Cypress");
> > +MODULE_DEVICE_TABLE(i2c, cyttsp_i2c_id);
> 


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
