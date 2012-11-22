Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2KVTyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:54:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28352 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab2KVTyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:54:25 -0500
X-AuditID: cbfee61b-b7f616d00000319b-e7-50add7d2335e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/3] charger-manager: Bug fix and split _probe function
Date: Thu, 22 Nov 2012 16:44:03 +0900
Message-id: <1353570243-18920-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t8zLd1L19cGGPzZo2lxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyZi2/xlLwl7ni4KHVzA2Mc5m7GDk5JARMJPZt/8EEYYtJXLi3
	nq2LkYtDSGAZo8SN02dYuhg5wIp2tIhDxBcxSjTMWwBVtJRJ4s+9pWCT2AS0JPa/uMEGYosI
	yEm8XvsXbCqzQK3EvmtNrCC2sIC7xMYPx9lBbBYBVYkjd64xgti8Aq4SRzuXMkJcoSDRuuwQ
	VI2AxLfJh6COkJXYdIAZZK+EwB42iQ0f/rJB1EtKHFxxg2UCo+ACRoZVjKKpBckFxUnpuUZ6
	xYm5xaV56XrJ+bmbGCEhJb2DcVWDxSFGAQ5GJR7eDIO1AUKsiWXFlbmHGCU4mJVEeBcVAIV4
	UxIrq1KL8uOLSnNSiw8x+gBdMpFZSjQ5HxjueSXxhsYGxoaGloZmppamBjiElcR5mz1SAoQE
	0hNLUrNTUwtSi2DGMXFwSjUw8t1/+lV2otdFjq8zO1U3F7y+bFc6e9dE3103d4jv8dh3Yl+V
	s7af7yPNbdyy2heLj560TRWylZgVyv7p07E9Xb9qXWQNntzJiFFeK7+S+cFWzRN7pbw8KnS/
	8s9kcAs6K5Hy6f+Einfbnz7zk/Gsiq/Pu6E5W9o3aUvUbrOflhf4nll17Lt2XImlOCPRUIu5
	qDgRADQjLFhWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t9jAd1L19cGGLw/IG9xedccNgdGj8+b
	5AIYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	pioplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM2Ytv8ZS8Je54uCh1cwN
	jHOZuxg5OCQETCR2tIh3MXICmWISF+6tZ+ti5OIQEljEKNEwbwGUs5RJ4s+9pcwgVWwCWhL7
	X9xgA7FFBOQkXq/9ywRiMwvUSuy71sQKYgsLuEts/HCcHcRmEVCVOHLnGiOIzSvgKnG0cykj
	xDYFidZlh9gnMHIvYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcsM+kdzCuarA4xCjA
	wajEw5thsDZAiDWxrLgy9xCjBAezkgjvogKgEG9KYmVValF+fFFpTmrxIUYfoO0TmaVEk/OB
	0ZRXEm9obGJmZGlkZmxibmyMQ1hJnLfZIyVASCA9sSQ1OzW1ILUIZhwTB6dUA2MUz/nTaQ1a
	rAk/OqTfi//TztF44B/YvkaGacm+ief6jp7+qcqrovHYedpUhl8Xm3Nur2l0tV1j8HbpnkR/
	v0sro7+e4k2TnPrFNnlZf3N/3MH591eqhWp+XWX/IfnslYw7kqqzn5iryXEkVFaeeKW+d/PJ
	FhtvruZUfzsL1SlHthf2Hixacl2JpTgj0VCLuag4EQCj618yhQIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset include bug fix patch and code clean to split _probe function
because _probe function is longer than 400 line.

Chanwoo Choi (3):
  charger-manager: Fix bug related to checking fully charged state of
    battery
  charger-manager: Fix bug when check dropped voltage after fullbatt
    event
  charger-manager: Split _probe funtion for code clean

 drivers/power/charger-manager.c |  321 +++++++++++++++++++++++----------------
 1 files changed, 187 insertions(+), 134 deletions(-)

