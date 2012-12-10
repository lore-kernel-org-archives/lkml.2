Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab2LJGUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 01:20:17 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:63095 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab2LJGUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 01:20:15 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-5c-50c57f1e44ff
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Cc: dianders@chromium.org, olof@lixom.net, grant.likely@secretlab.ca,
        thomas.abraham@linaro.org, kgene.kim@samsung.com,
        sameo@linux.intel.com, Abhilash Kesavan <a.kesavan@samsung.com>
Subject: [RFC PATCH 0/3] Add MAX77686 Operating mode support
Date: Mon, 10 Dec 2012 11:56:21 +0530
Message-id: <1355120784-31118-1-git-send-email-a.kesavan@samsung.com>
X-Mailer: git-send-email 1.6.6.1
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsWyRsSkSleu/miAwYIPIhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj5tmNrAWvOCr2n/rO1MDYyd7FyMkhIWAi0fxmKzOELSZx4d56
	ti5GLg4hgaWMErfXXmOGKeqZ94EJIrGIUWL13T52CGc5k8SFSfvYQKrYBPQkFvz7CtYhIhAs
	MftnA9goZoHdjBIP3iwBSwgL2Egcnf6UCcRmEVCVWL/gOguIzSvgKnHw9F6odQoSpz+sZYeo
	EZD4NvkQUA0HUFxWYtMBqJI9bBJHF0tD2JISB1fcYJnAKLiAkWEVo2hqQXJBcVJ6rqFecWJu
	cWleul5yfu4mRmBQnf73TGoH48oGi0OMAhyMSjy8AYpHA4RYE8uKK3MPMUpwMCuJ8HIdOxIg
	xJuSWFmVWpQfX1Sak1p8iNEH6JCJzFKiyfnAgM8riTc0NjE3NTa1NDIyMzXFIawkztvskRIg
	JJCeWJKanZpakFoEM46Jg1OqgXHyhPf+z26YXFr+RvOiRFPztO2PN+hYZb/yv2NhPOsy873g
	NS1eGbdnZEUxm6S2mGzj339NTvX3PPe1JdMD7Opu7p3zfPrGunupNoYWytumJi3kcIisfejX
	x7bsD0fcfecX7hFGu/tzCt/6hzz26Prz9cg7gSdshmFWWZXdF1Mnv5tVYHDqwSwlluKMREMt
	5qLiRACks3rVVwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t9jAV25+qMBBusXsVhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjJtnN7IWvOKo2H/qO1MD
	Yyd7FyMnh4SAiUTPvA9MELaYxIV769m6GLk4hAQWMUqsvtvHDuEsZ5K4MGkfG0gVm4CexIJ/
	X5lBbBGBYInZPxvAOpgFdjNKPHizBCwhLGAjcXT6U7CxLAKqEusXXGcBsXkFXCUOnt7LDLFO
	QeL0h7XsExi5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDtpnUjsYVzZYHGIU4GBU
	4uENUDwaIMSaWFZcmXuIUYKDWUmEl+vYkQAh3pTEyqrUovz4otKc1OJDjD5A2ycyS4km5wMj
	Kq8k3tDYxNzU2NTSxMLEzBKHsJI4b7NHSoCQQHpiSWp2ampBahHMOCYOTqkGRp1jv64c2dF5
	9V3CbyaR5Q0/cnVmX/IpPPL7oJFl1BU56euKtUZLxHe6TT2x87FWYbj8nP8Vk2zM3oV+nvn4
	toSritqKGYKrEz8eTjvJ3fDf41G+1g3Ohz4LHVivpaXd982Z0+3x+prH1k3O7RoHvdtXvJDu
	rgvJqq/+fGbLr02TlLxnrJ/ypkCJpTgj0VCLuag4EQCJdAnqhwIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we cannot specify the regulator suspend state via device
tree. Rather than adding suspend state/mode/enable/disable properties
add an optional MAX77686 operating mode property which can be used to
set the regulator mode initially.

We are currently bypassing the set_suspend_disable and set_suspend_mode
call-backs. Please review and suggest improvements.

This is based on
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git : for-next
merged with
git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git : for-next


Abhilash Kesavan (3):
  ARM: DTS: CROS5250: Add regulator operating mode bindings
  regulator: max77686: Add support for various operating modes
  dt: Document: Add optional MAX77686 operating mode bindings

 Documentation/devicetree/bindings/mfd/max77686.txt |    6 +++
 arch/arm/boot/dts/cros5250-common.dtsi             |   36 ++++++++++++++++++++
 drivers/regulator/max77686.c                       |   11 +++++-
 include/linux/mfd/max77686.h                       |    1 +
 4 files changed, 53 insertions(+), 1 deletions(-)

-- 
1.7.8.6

