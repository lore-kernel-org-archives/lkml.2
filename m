Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab1J0T1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 15:27:52 -0400
Received: from nm9-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.196]:30519 "HELO
	nm9-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751475Ab1J0T1v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 15:27:51 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 930204.56919.bm@omp1034.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=EsVQU5HVwx31suhgwm29/0Cu+n0hnt8mkA44MI/ZpOmL19hU5KODVSpOKmroEAvIZu+SE3xqTRHs/oG/BgeikgweVz7OQY0KK+1yh0ZQdaeJ9i7Y+zDb+orejwCIZGJnwZTQ317Uxf13lYEgO0Hw51QZ1a58gnBZwDYUtm34dws=;
X-YMail-OSG: 0iqd1wQVM1lb.CuYeLNkenASIrlbVxFVgd6p19zhV.F5PKV
 G.JbbrH22e3emMIbTHVy8OhtpohF5ePTBeZcxcT1J9_Hm9HAafkvAe6yshtA
 lSJF1s04Hn4z.gzcYmbxEJ9YKw0x3NMENMKA6XFbvxTgaIXoW8U6I0ZtyhEV
 CIYfD92HD.fFQIIEhWtMJTxBNv8iwW0GWpX42jVfQn8qvvXGZxGuN.qlMlCx
 QbpC50oYSifT9XchUTL..Xt_h_IfkGHKeTqrbMZQlg2ZQSjZQvIM17YYWszk
 8HE_w2Bi5Rx_.mXQdbSY8VvCZFYnEmT_SysZospD7BMmzqkDKQnzhoQgCeAn
 t9Wc4IwCDm0lohsmeXQeHZ2cl9yd4X87DPP34NUgKghGKFou7o1ldkl37dTP
 xO9kx2KC0Idev8q8HiNjMHPnhdP3U0lqvRw2.UFh0n3f8GJIx3wtxKqeYbBX
 ZOi4vZLm_.cl1X0c9hnAOfBZ7ZmC.x3.zUvz8yjT2UAw0HTNeYqml_A.ETqI
 ldTHEsTBcagxo_FnlLhdAfmwg
X-Mailer: YahooMailWebService/0.8.114.317681
Message-ID: <1319743670.62757.YahooMailNeo@web130109.mail.mud.yahoo.com>
Date: Thu, 27 Oct 2011 12:27:50 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re:[bisected] i915 dpms does not switch back light on
To: "wmkoolen@science.uva.nl" <wmkoolen@science.uva.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Hi guys,
>
>After update from kernel 3.0.8 to 3.1 I encounter the following problem. 
>When power saving turns off the back light, key/mouse activity does not 
>turn it back on. I can turn it back on by pressing the "brightness++" key.


I've been having this problem as well. I created a patch that fixes the problem for me and others:

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index 6f56676..a9e0c7b 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -262,6 +262,8 @@ void intel_panel_disable_backlight(struct drm_device *dev)
                dev_priv->backlight_level = intel_panel_get_backlight(dev);
                dev_priv->backlight_enabled = false;
        }
+
+       intel_panel_set_backlight(dev, 0);
 }


For more info, see http://marc.info/?l=linux-kernel&m=131959957117710&w=2

I code, therefore I am
