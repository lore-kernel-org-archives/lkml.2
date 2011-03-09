Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab1CIN7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 08:59:34 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51586 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab1CIN7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:59:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=vYO9vnufdI8xEKHeGKs079xVFXwkreTlkgwe0wV+GqwN/K13WWFPkv3MKTqU555qjs
         mP1VFI3hEXIn0VD5MsjWPXGAAkjETqdrnUXDLJIcRAbQWZm3jS5/SuvOLTPZajdOE/9+
         Kp/t1P9sF1X6n9XBqJKEZ/LfFxUcTvqIKO52Q=
Date: Wed, 9 Mar 2011 10:59:25 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, phan@redhat.com
Subject: Re: [PATCH 1/2] perf,top: fix events overflow in top command
Message-ID: <20110309135925.GA20188@ghostprotocols.net>
References: <1299528821-17521-1-git-send-email-jolsa@redhat.com>
 <1299528821-17521-2-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299528821-17521-2-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 07, 2011 at 09:13:40PM +0100, Jiri Olsa escreveu:
> The snprintf function returns number of printed characters even
> if it cross the size parameter. So passing enough events via '-e'
> parameter will cause segmentation fault.
> 
> It's reproduced by following command:
> 
> perf top -e `perf list | grep Tracepoint | awk -F'[' '\
> {gsub(/[[:space:]]+/,"",$1);array[FNR]=$1}END{outputs=array[1];\
> for (i=2;i<=FNR;i++){ outputs=outputs "," array[i];};print outputs}'`
> 
> Attached patch is adding SNPRINTF macro that provides the
> overflow check and returns actuall number of printed characters.

Good catch, applying to perf/urgent.

- Arnaldo
