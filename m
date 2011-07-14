Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1GNIHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 04:07:19 -0400
Received: from nm11.bullet.mail.ird.yahoo.com ([77.238.189.64]:40159 "HELO
	nm11.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753715Ab1GNIHQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 04:07:16 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 64868.38502.bm@omp1031.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=OfEtxIpy3U6aapenTpxTGRG8jrus6O8ejCMmeXRZSyuE+mTP1HOBwO969cOB6/A1O0RJ26rHd0812G3GVVsUue29YMCtlpKE3NhyHhBSV3BKh+1FUNUv3WlzW6xImnjqkCrGStJzVS5kGJxX69hFdpY0sjfnex6mJs+YuB19VT4=;
X-YMail-OSG: Rj1nghoVM1m51WwIHFLpYj8HFPt27FVUncPBpF22p6fYOKG
 oG0WrCf33qxqXVGU9ciWol8UP74.eHf8SWjmO3IJaeWMa_JyjLju58R_dQzM
 TB7xglPPgW2tO8yKUEjh8uONRZKOJqkSeBs3ijYRFftSAT9MhnSWitcDg.rE
 410AsBKz45XIH5epVtl2ldlz1X_gzfiR0S01Ygn4.LE3IGVZG3PxKd.qWp4K
 RwVHwWilEXEGq3lAoriKMZj_miPkKDAHceihb7.wntZyocPbmuLkxLLBGHVM
 hW89iPNWioCeXIvPD9GgYxOt4WvaBvWejtNPonp0JA_6SJk1HcVgpSuqeOXb
 XHRssFYjUKi2ijYKz7w--
X-Mailer: YahooMailClassic/14.0.3 YahooMailWebService/0.8.112.307740
Message-ID: <1310630834.622.YahooMailClassic@web29508.mail.ird.yahoo.com>
Date: Thu, 14 Jul 2011 09:07:14 +0100 (BST)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: [PATCH] hfsplus: Add record offset check
To: Naohiro Aota <naota@elisp.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <87k4blyga3.fsf@elisp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 13/7/11, Naohiro Aota <naota@elisp.net> wrote:

<snipped>
> hfsplus_bnode_read() which is called from
> hfsplus_bnode_read_u16(), is
> causing the fault. Since hfs_bnode_read_u16() can return
> any u16
> numbers, we cannot assume some value as "error code", so it
> is difficult
> to check the error in hfsplus_bnode_read*(). Actually there
> is no way to
> report the range error to the callers. If we'd like to
> check the range
> and offset in hfsplus_bnode_read(), we need to modify not
> only
> hfsplus_bnode_read() but also all the function callers.
> Would it be a
> better solution? I don't think so.
> 
> Even if there is another root cause of this fault here I
> have, it's
> still a big problem. Because 'recoff' is come from disk, it
> is easily
> fuzzed to have invalid out of range value, and it cause the
> fault, and
> make the file system completely unavailable untill the next
> reboot.
> 
> About bad-side effects: I don't think there is serious
> bad-side
> effects. Above this patch code, 'recoff' is checked and if
> it is 0 and
> below this patch code, 'retval' (= keylen) is checked to be
> in
> acceptable range. In both case, hfsplus_brec_keylen()
> return 0. My patch
> is just doing additional check. The caller of
> hfsplus_brec_keylen()
> should be able to handle this 0 value as error code. If
> there is some
> bad-side effect, the caller may also fail to handle
> 'recoff' == 0 case
> or too large 'retval' (keylen) case. That should be another
> bug.
<snipped>

> Purpose of this patch is as same as commit
> 9250f925972d03ccc0c0a4dd4e9b794d2ef6d52b. This is a patch
> to handle
> on-disk corruption without oopsing.
>

I am not disputing that the current kernel code is broken - I am disputing your _explanation_ and _appoach_ of it. The most important part of your exposition above to accompany the change proposed is this: 
 
"The caller of hfsplus_brec_keylen() should be able to handle this 0 value as error code."

Something to this effect should be in your initial commit log message, or in the patch itself. (e.g. "/* return error state for caller to handle */").

