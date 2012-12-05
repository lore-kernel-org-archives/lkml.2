Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab2LEXK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 18:10:57 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50650 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab2LEXKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 18:10:55 -0500
Date: Wed, 5 Dec 2012 17:09:41 -0600
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Mathias LEBLANC <Mathias.LEBLANC@st.com>,
        Jean-Luc BLANC <jean-luc.blanc@st.com>,
        "Sirrix@jasper.es" <Sirrix@jasper.es>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <mail@srajiv.net>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        Kent Yoder <shpedoikal@gmail.com>
Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics ST33 I2C
 KERNEL 3.x.x
Message-ID: <20121205230941.GA30394@ennui.austin.ibm.com>
References: <1353363322-2923-1-git-send-email-mathias.leblanc@st.com>
 <20121205174527.GF21050@ennui.austin.ibm.com>
 <20121205180720.GG21050@ennui.austin.ibm.com>
 <201212052214.48840.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201212052214.48840.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120523-5806-0000-0000-00001C996523
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 10:14:48PM +0100, Peter Hüwe wrote:
> Hi Kent, Matthias,
> 
> Am Mittwoch, 5. Dezember 2012, 19:07:20 schrieb Kent Yoder:
> >   Heh, duh, well of course it is. I've now staged everything I'm
> > planning on pushing at:
> > 
> > git://github.com/shpedoikal/linux.git tpmdd-12-05-12
> > 
> > Please test and let me know if I missed anything.
> 
> 
> I just checked out your commit from github.
> 
> Here's a part of the review:
> 
> Smatch still complains a bit, sparse is fine.:
> 
>  make -C /data/data-old/linux-2.6/ M=`pwd` C=1 CHECK=smatch modules
> make: Entering directory `/data/data-old/linux-2.6'
>   CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:535 tpm_stm_i2c_recv() warn: variable dereferenced before check 'chip' (see line 531)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:748 tpm_st33_i2c_probe() warn: variable dereferenced before check 'platform_data' (see line 659)
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:848 tpm_st33_i2c_pm_resume() warn: should this be a bitwise op?
> /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.c:848 tpm_st33_i2c_pm_resume() warn: should this be a bitwise op?
>   CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.o
>   Building modules, stage 2.
>   MODPOST 6 modules
>   LD [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_stm_st33_i2c.ko
> make: Leaving directory `/data/data-old/linux-2.6'
> 
> Please check.
> 
> 
> (maybe also fix the checkpatch -strict stuff as well? Would be nice ;)
> 
> 
> 
> 
> 
> drivers/char/tpm/tpm_stm_st33_i2c.h 
> - Does the driver really need a seperate headerfile in drivers/char/tpm/ ? for me it seems everything can be included into the c-file.
> 
> > struct st_tpm_hash {
> >	int size;
> >	u8 *data;
> > };
> is unused - please remove.
> 
> > #define MINOR_NUM_I2C		224
> Please remove, it's unused and if you really need it use the one from tpm.h
> 
> include/linux/i2c/tpm_stm_st33_i2c.h
> I'm not sure if this is needed publicly? Or does only your driver need this?
> 
> >struct st33zp24_platform_data {
> Telling from the name I have no idea what this device is.
> 
> 
> 
> 
> 
> drivers/char/tpm/tpm_stm_st33_i2c.c
> 
> >enum stm33zp24_int_flags {
> >	TPM_GLOBAL_INT_ENABLE = 0x80,
> >	TPM_INTF_CMD_READY_INT = 0x080,
> >	TPM_INTF_FIFO_AVALAIBLE_INT = 0x040,
> >	TPM_INTF_WAKE_UP_READY_INT = 0x020,
> >	TPM_INTF_LOCALITY_CHANGE_INT = 0x004,
> >	TPM_INTF_STS_VALID_INT = 0x002,
> >	TPM_INTF_DATA_AVAIL_INT = 0x001,
> >};
> 
> Why the leading zeros? please remove.
> 
> 
> > static int tpm_st33_i2c_pm_suspend(struct i2c_client *client, pm_message_t mesg)
> >...
> > static int tpm_st33_i2c_pm_resume(struct i2c_client *client)
> >,,,
> >static struct i2c_driver tpm_st33_i2c_driver = {
> >	.driver = {
> >		   .owner = THIS_MODULE,
> >		   .name = TPM_ST33_I2C,
> >		   },
> >	.probe = tpm_st33_i2c_probe,
> >	.remove = tpm_st33_i2c_remove,
> >	.resume = tpm_st33_i2c_pm_resume,
> >	.suspend = tpm_st33_i2c_pm_suspend,
> >	.id_table = tpm_st33_i2c_id
> >};
> 
> Please convert resume/suspend  to .driver.pm 
> 
> It's pretty easy.
> See this post  for details
> http://sourceforge.net/mailarchive/message.php?msg_id=29516784
> Rafael did spent quite a lot of effort to convert almost every driver back then, so we should 'fix' new ones.

Not sure how easy this will be considering these routines are
i2c-specific -- they don't just call the tpm_tpm_* functions like the
other drivers.

Anyway, I left this off but I believe I've fixed up the other major
issues. We can leave the more nit-picky stuff for another day.

Please test:

git://github.com/shpedoikal/linux.git tpmdd-12-06-12

Kent

> 
> 
> > /*
> >  * tpm_st33_i2c_init initialize driver
> >  * @return: 0 if successful, else non zero value.
> >  */
> > static int __init tpm_st33_i2c_init(void)
> > {
> > 	return i2c_add_driver(&tpm_st33_i2c_driver);
> > }
> > 
> > /*
> >  * tpm_st33_i2c_exit The kernel calls this function during unloading the
> >  * module or during shut down process
> >  */
> > static void __exit tpm_st33_i2c_exit(void)
> > {
> > 	i2c_del_driver(&tpm_st33_i2c_driver);
> > }
> > 
> > module_init(tpm_st33_i2c_init);
> > module_exit(tpm_st33_i2c_exit);
> 
> Hooray for oneliners ;)
> + module_i2c_driver(tpm_st33_i2c_driver);
> 
> 
> 
> Keep on hacking ;)
> 
> Thanks,
> PeterH
> 
> 

