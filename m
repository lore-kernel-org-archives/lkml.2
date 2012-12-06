Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab2LFAJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 19:09:59 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:35507 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751980Ab2LFAJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 19:09:58 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/oexcaQ93oK6kloeVnE9rSCxW3BpsYrtSKpG9Gsm
	dDTGBLvFe3W91D
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Kent Yoder <key@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics ST33 I2C KERNEL 3.x.x
Date: Thu, 6 Dec 2012 01:10:32 +0100
User-Agent: KMail/1.13.7 (Linux/3.6.9; KDE/4.8.5; x86_64; ; )
Cc: Mathias LEBLANC <Mathias.LEBLANC@st.com>,
        "Jean-Luc BLANC" <jean-luc.blanc@st.com>,
        "Sirrix@jasper.es" <Sirrix@jasper.es>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <mail@srajiv.net>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        Kent Yoder <shpedoikal@gmail.com>
References: <1353363322-2923-1-git-send-email-mathias.leblanc@st.com> <201212052214.48840.PeterHuewe@gmx.de> <20121205230941.GA30394@ennui.austin.ibm.com>
In-Reply-To: <20121205230941.GA30394@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212060110.32227.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 6. Dezember 2012, 00:09:41 schrieb Kent Yoder:
> > 
> > > static int tpm_st33_i2c_pm_suspend(struct i2c_client *client,
> > > pm_message_t mesg)
> > >
> > >...
> > >
> > > static int tpm_st33_i2c_pm_resume(struct i2c_client *client)
> > >
> > >,,,
> > >static struct i2c_driver tpm_st33_i2c_driver = {
> > >
> > >	.driver = {
> > >	
> > >		   .owner = THIS_MODULE,
> > >		   .name = TPM_ST33_I2C,
> > >		   },
> > >	
> > >	.probe = tpm_st33_i2c_probe,
> > >	.remove = tpm_st33_i2c_remove,
> > >	.resume = tpm_st33_i2c_pm_resume,
> > >	.suspend = tpm_st33_i2c_pm_suspend,
> > >	.id_table = tpm_st33_i2c_id
> > >
> > >};
> > 
> > Please convert resume/suspend  to .driver.pm
> > 
> > It's pretty easy.
> > See this post  for details
> > http://sourceforge.net/mailarchive/message.php?msg_id=29516784
> > Rafael did spent quite a lot of effort to convert almost every driver
> > back then, so we should 'fix' new ones.
> 
> Not sure how easy this will be considering these routines are
> i2c-specific -- they don't just call the tpm_tpm_* functions like the
> other drivers.

Why are they really i2c-specific?
The only i2c specific part is the i2c_get_clientdata - which calls 
get_dev_drvdata internally.
And I since we already get the correct struct device we don't need to use 
TPM_VPRIV in order to access the platform data. 

I'll send a patch - see next email.
@Matthias: can you please test this? As I cannot do this.


Thanks,
Peter


