Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab1AaFQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 00:16:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58900 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab1AaFQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 00:16:42 -0500
Date: Mon, 31 Jan 2011 16:16:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-Id: <20110131161640.93d8688a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c between commit
f32b8453e5a5587ae112ba478ae0bbad74e83d22 ("Staging: ste_rmi4: use after
input_unregister_device()") from the staging.current tree and commit
dc7b202a4ee6cb686e2bbef80c84443f43ec91bd ("staging/ste_rmi4: Remove
obsolete cleanup for clientdata") from the staging tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
index 80183a7,fa1ee9d..0000000
--- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
+++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
@@@ -997,21 -1001,14 +995,19 @@@ static int __devinit synaptics_rmi4_pro
  	if (retval) {
  		dev_err(&client->dev, "%s:Unable to get attn irq %d\n",
  				__func__, platformdata->irq_number);
- 		goto err_unset_clientdata;
 -		goto err_request_irq;
++		goto err_query_dev;
 +	}
 +
 +	retval = input_register_device(rmi4_data->input_dev);
 +	if (retval) {
 +		dev_err(&client->dev, "%s:input register failed\n", __func__);
 +		goto err_free_irq;
  	}
  
  	return retval;
  
 -err_request_irq:
 +err_free_irq:
  	free_irq(platformdata->irq_number, rmi4_data);
- err_unset_clientdata:
- 	i2c_set_clientdata(client, NULL);
 -	input_unregister_device(rmi4_data->input_dev);
  err_query_dev:
  	if (platformdata->regulator_en) {
  		regulator_disable(rmi4_data->regulator);
