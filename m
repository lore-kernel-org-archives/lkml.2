Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423691Ab2LFPHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:07:52 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:38039 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423646Ab2LFPHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:07:51 -0500
Date: Thu, 6 Dec 2012 09:06:45 -0600
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
Message-ID: <20121206150645.GA27430@ennui.austin.ibm.com>
References: <1353363322-2923-1-git-send-email-mathias.leblanc@st.com>
 <201212052214.48840.PeterHuewe@gmx.de>
 <20121205230941.GA30394@ennui.austin.ibm.com>
 <201212060110.32227.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201212060110.32227.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120615-5406-0000-0000-000002D114BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 01:10:32AM +0100, Peter Hüwe wrote:
> Am Donnerstag, 6. Dezember 2012, 00:09:41 schrieb Kent Yoder:
> > > 
> > > > static int tpm_st33_i2c_pm_suspend(struct i2c_client *client,
> > > > pm_message_t mesg)
> > > >
> > > >...
> > > >
> > > > static int tpm_st33_i2c_pm_resume(struct i2c_client *client)
> > > >
> > > >,,,
> > > >static struct i2c_driver tpm_st33_i2c_driver = {
> > > >
> > > >	.driver = {
> > > >	
> > > >		   .owner = THIS_MODULE,
> > > >		   .name = TPM_ST33_I2C,
> > > >		   },
> > > >	
> > > >	.probe = tpm_st33_i2c_probe,
> > > >	.remove = tpm_st33_i2c_remove,
> > > >	.resume = tpm_st33_i2c_pm_resume,
> > > >	.suspend = tpm_st33_i2c_pm_suspend,
> > > >	.id_table = tpm_st33_i2c_id
> > > >
> > > >};
> > > 
> > > Please convert resume/suspend  to .driver.pm
> > > 
> > > It's pretty easy.
> > > See this post  for details
> > > http://sourceforge.net/mailarchive/message.php?msg_id=29516784
> > > Rafael did spent quite a lot of effort to convert almost every driver
> > > back then, so we should 'fix' new ones.
> > 
> > Not sure how easy this will be considering these routines are
> > i2c-specific -- they don't just call the tpm_tpm_* functions like the
> > other drivers.
> 
> Why are they really i2c-specific?
> The only i2c specific part is the i2c_get_clientdata - which calls 
> get_dev_drvdata internally.
> And I since we already get the correct struct device we don't need to use 
> TPM_VPRIV in order to access the platform data. 

 I was referring to the power mgmt stuff. Those functions take struct
device, not a i2c_client *.

Kent

> I'll send a patch - see next email.
> @Matthias: can you please test this? As I cannot do this.
> 
> 
> Thanks,
> Peter
> 
> 

