Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab2LCGMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 01:12:55 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60771 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2LCGMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 01:12:53 -0500
Date: Mon, 3 Dec 2012 17:12:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Vinod Koul <vinod.koul@linux.intel.com>,
        Bill Pemberton <wfp5p@virginia.edu>, Greg KH <greg@kroah.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: linux-next: manual merge of the arm-soc tree with the slave_dma and
  tree
Message-Id: <20121203171232.04772e84d18948bbbcafdeef@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Dec_2012_17_12_32_+1100_LonjnlzJd96rzL+n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Dec_2012_17_12_32_+1100_LonjnlzJd96rzL+n
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/dma/mv_xor.c between commit d51e88b99533 ("dma: Convert dev_printk
(KERN_<LEVEL> to dev_<level>(") from the slave-dma tree, commits
a7d6e3ec28bb ("dma: remove use of __devexit_p") and 463a1f8b3cee ("dma:
remove use of __devinit") from the driver-core tree and various commits
from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/dma/mv_xor.c
index 3ef4095,9659e58..0000000
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@@ -206,8 -209,8 +209,8 @@@ static void mv_set_mode(struct mv_xor_c
  		op_mode =3D XOR_OPERATION_MODE_MEMSET;
  		break;
  	default:
- 		dev_err(chan->device->common.dev,
+ 		dev_err(mv_chan_to_devp(chan),
 -			"error: unsupported operation %d.\n",
 +			"error: unsupported operation %d\n",
  			type);
  		BUG();
  		return;
@@@ -828,22 -828,28 +828,28 @@@ static void mv_dump_xor_regs(struct mv_
  	u32 val;
 =20
  	val =3D __raw_readl(XOR_CONFIG(chan));
- 	dev_err(chan->device->common.dev, "config       0x%08x\n", val);
+ 	dev_err(mv_chan_to_devp(chan),
 -		"config       0x%08x.\n", val);
++		"config       0x%08x\n", val);
 =20
  	val =3D __raw_readl(XOR_ACTIVATION(chan));
- 	dev_err(chan->device->common.dev, "activation   0x%08x\n", val);
+ 	dev_err(mv_chan_to_devp(chan),
 -		"activation   0x%08x.\n", val);
++		"activation   0x%08x\n", val);
 =20
  	val =3D __raw_readl(XOR_INTR_CAUSE(chan));
- 	dev_err(chan->device->common.dev, "intr cause   0x%08x\n", val);
+ 	dev_err(mv_chan_to_devp(chan),
 -		"intr cause   0x%08x.\n", val);
++		"intr cause   0x%08x\n", val);
 =20
  	val =3D __raw_readl(XOR_INTR_MASK(chan));
- 	dev_err(chan->device->common.dev, "intr mask    0x%08x\n", val);
+ 	dev_err(mv_chan_to_devp(chan),
 -		"intr mask    0x%08x.\n", val);
++		"intr mask    0x%08x\n", val);
 =20
  	val =3D __raw_readl(XOR_ERROR_CAUSE(chan));
- 	dev_err(chan->device->common.dev, "error cause  0x%08x\n", val);
+ 	dev_err(mv_chan_to_devp(chan),
 -		"error cause  0x%08x.\n", val);
++		"error cause  0x%08x\n", val);
 =20
  	val =3D __raw_readl(XOR_ERROR_ADDR(chan));
- 	dev_err(chan->device->common.dev, "error addr   0x%08x\n", val);
+ 	dev_err(mv_chan_to_devp(chan),
 -		"error addr   0x%08x.\n", val);
++		"error addr   0x%08x\n", val);
  }
 =20
  static void mv_xor_err_interrupt_handler(struct mv_xor_chan *chan,
@@@ -855,8 -861,8 +861,8 @@@
  	     return;
  	}
 =20
- 	dev_err(chan->device->common.dev,
+ 	dev_err(mv_chan_to_devp(chan),
 -		"error on chan %d. intr cause 0x%08x.\n",
 +		"error on chan %d. intr cause 0x%08x\n",
  		chan->idx, intr_cause);
 =20
  	mv_dump_xor_regs(chan);
@@@ -895,7 -901,7 +901,7 @@@ static void mv_xor_issue_pending(struc
   */
  #define MV_XOR_TEST_SIZE 2000
 =20
- static int mv_xor_memcpy_self_test(struct mv_xor_device *device)
 -static int __devinit mv_xor_memcpy_self_test(struct mv_xor_chan *mv_chan)
++static int mv_xor_memcpy_self_test(struct mv_xor_chan *mv_chan)
  {
  	int i;
  	void *src, *dest;
@@@ -969,8 -970,8 +970,8 @@@ out
  }
 =20
  #define MV_XOR_NUM_SRC_TEST 4 /* must be <=3D 15 */
 -static int __devinit
 +static int
- mv_xor_xor_self_test(struct mv_xor_device *device)
+ mv_xor_xor_self_test(struct mv_xor_chan *mv_chan)
  {
  	int i, src_idx;
  	struct page *dest;
@@@ -1199,26 -1188,28 +1187,27 @@@ mv_xor_channel_add(struct mv_xor_devic
  	}
 =20
  	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)) {
- 		ret =3D mv_xor_xor_self_test(adev);
+ 		ret =3D mv_xor_xor_self_test(mv_chan);
  		dev_dbg(&pdev->dev, "xor self test returned %d\n", ret);
  		if (ret)
- 			goto err_free_dma;
+ 			goto err_free_irq;
  	}
 =20
 -	dev_info(&pdev->dev, "Marvell XOR: "
 -	  "( %s%s%s%s)\n",
 -	  dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
 -	  dma_has_cap(DMA_MEMSET, dma_dev->cap_mask)  ? "fill " : "",
 -	  dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask) ? "cpy " : "",
 -	  dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask) ? "intr " : "");
 +	dev_info(&pdev->dev, "Marvell XOR: ( %s%s%s%s)\n",
 +		 dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
 +		 dma_has_cap(DMA_MEMSET, dma_dev->cap_mask)  ? "fill " : "",
 +		 dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask) ? "cpy " : "",
 +		 dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask) ? "intr " : "");
 =20
  	dma_async_device_register(dma_dev);
- 	goto out;
+ 	return mv_chan;
 =20
+ err_free_irq:
+ 	free_irq(mv_chan->irq, mv_chan);
   err_free_dma:
- 	dma_free_coherent(&adev->pdev->dev, plat_data->pool_size,
- 			adev->dma_desc_pool_virt, adev->dma_desc_pool);
-  out:
- 	return ret;
+ 	dma_free_coherent(&pdev->dev, MV_XOR_POOL_SIZE,
+ 			  mv_chan->dma_desc_pool_virt, mv_chan->dma_desc_pool);
+ 	return ERR_PTR(ret);
  }
 =20
  static void
@@@ -1250,27 -1241,22 +1239,22 @@@ mv_xor_conf_mbus_windows(struct mv_xor_
 =20
  	writel(win_enable, base + WINDOW_BAR_ENABLE(0));
  	writel(win_enable, base + WINDOW_BAR_ENABLE(1));
+ 	writel(0, base + WINDOW_OVERRIDE_CTRL(0));
+ 	writel(0, base + WINDOW_OVERRIDE_CTRL(1));
  }
 =20
- static struct platform_driver mv_xor_driver =3D {
- 	.probe		=3D mv_xor_probe,
- 	.remove		=3D mv_xor_remove,
- 	.driver		=3D {
- 		.owner	=3D THIS_MODULE,
- 		.name	=3D MV_XOR_NAME,
- 	},
- };
-=20
- static int mv_xor_shared_probe(struct platform_device *pdev)
 -static int __devinit mv_xor_probe(struct platform_device *pdev)
++static int mv_xor_probe(struct platform_device *pdev)
  {
  	const struct mbus_dram_target_info *dram;
- 	struct mv_xor_shared_private *msp;
+ 	struct mv_xor_device *xordev;
+ 	struct mv_xor_platform_data *pdata =3D pdev->dev.platform_data;
  	struct resource *res;
+ 	int i, ret;
 =20
- 	dev_notice(&pdev->dev, "Marvell shared XOR driver\n");
+ 	dev_notice(&pdev->dev, "Marvell XOR driver\n");
 =20
- 	msp =3D devm_kzalloc(&pdev->dev, sizeof(*msp), GFP_KERNEL);
- 	if (!msp)
+ 	xordev =3D devm_kzalloc(&pdev->dev, sizeof(*xordev), GFP_KERNEL);
+ 	if (!xordev)
  		return -ENOMEM;
 =20
  	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);

--Signature=_Mon__3_Dec_2012_17_12_32_+1100_LonjnlzJd96rzL+n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQvELQAAoJEECxmPOUX5FEbu8QAJ7niOpKkU+dXacNeXHDX9Wo
Q5Yc6RbeDL946Tx1KByQNpM+dONGsjaenHQY3vB09zYX//VYUIMG6NmAdCfq2yd7
feUk+QvgyKadJYVkQm2QRVw9s83l+0OFHtwwYsVugjHMSKAdWUsRGGiMobXCa+0m
dCvPYNURtk3SPIc3GyLqVsTpxOy2Dto7MDULeCTBNtybSC22X2ne2G+NLSmyLSGZ
PAbu5v1S9QIsfIp5SHWDdchYLacyqBMJiLvX8LcxjXkaWdTC23e+e3ZwHCBtVyYf
74TfMy9Xf4xq0gCzEfYYFU1IRn05punWEWDKDCNz/v6NneawJgF9muXPrdKzsm4E
zVHMLsTYKdBwgFyc+XqNnrkmq1l9SMoH/QU/OR/mKQeG64mqCcsvlRbisvU6hpO6
dVZGIiUaQNDm5bNZqyG2n7I95HxXKaofHcaciPF8OA16kFQ+2nckGFxt4eCJC/dm
JgtY++XqFofMnHZ0lSxRJ28rvi6HXU0Iylgp/WMx5CClB7VTnY/LDT64TV+84ncb
rK6RGvWBZe/2qlX8Hhf5R5zvpkU585tBzyFaYrst8vWpeh9qF5pDjOgW5+HdyNnr
o6/VNnWzD6MtGhvH0VwUrz5N9aX2cI5snwKiQOOEnxLRHKkuGk5wiCCa5qYMpA7K
id0Ujfp2efFpqf2m4wd+
=7Q4y
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Dec_2012_17_12_32_+1100_LonjnlzJd96rzL+n--
