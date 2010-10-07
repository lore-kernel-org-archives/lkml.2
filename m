Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab0JGUNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:13:53 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:42656 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752153Ab0JGUNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:13:53 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: BGveTpYVM1mbCcmPj59xOd3fAg9W.Fo.Xa7jx7e9ui.0XAf
 wJrA0lhZZaLK_qW_1lsR.1regasdLib0xrNlU_T0E8GUIr0XiohPdPAbE5Uk
 q4ZFqQ8omk2ocbXyYXIK_129IjkfBGfmC4gy2bQQJ.mdj4MTvCCST366js2w
 Y2nm3gMUVBQHQY8D.RwdM8rpm6ktCaW_mVekOda74rsLVBiVD8gFXMN_IKLv
 rKBBjlp0LBk9WgeCcJIlB48ZKke8Q
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 7 Oct 2010 15:13:48 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] percpu_counter: change inaccurate comment
In-Reply-To: <1286481860.3745.30.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1010071509180.28032@router.home>
References: <1286469421.2912.240.camel@edumazet-laptop>  <alpine.DEB.2.00.1010071440220.28032@router.home> <1286481860.3745.30.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Oct 2010, Eric Dumazet wrote:

> If enclosed by preempt_disable()/preempt_enable(), maybe we could use
> __this_cpu_ptr() ?

The only difference between __this_cpu_ptr and this_cpu_ptr is that
this_cpu_ptr checks that preempt was disabled. __this_cpu_ptr allows use
even without preempt. Preempt must be disabled here so the use of
this_cpu_ptr is appropriate.


