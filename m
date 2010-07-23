Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab0GWAPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 20:15:12 -0400
Received: from mail.agmk.net ([91.192.224.71]:33587 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab0GWAPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 20:15:10 -0400
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: AoE: undetected corruption of single bits?
Date: Fri, 23 Jul 2010 02:15:01 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.1-3; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007230215.02040.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

i'm testing a cluster filesystem ocfs2 with rad10-over-AoE backend
and discovered some fancy data corruption during svn checkout.

here's a diff between good checkout stored on nfs and broken on ocfs2 (gfs2 also have similar errors).


--- /remote/nfs/home/pawels/foo/trunk/buildenv/linux/gcc-4.3/32/boost-1.42.0/include/boost/graph/graph_utility.hpp
+++ /remote/cluster/pawels/foo/trunk/buildenv/linux/gcc-4.3/32/boost-1.42.0/include/boost/graph/graph_utility.hpp
@@ -376,7 +376,7 @@
   template <typename VertexListGraph, typename VertexColorMap>
   inline bool is_connected(const VertexListGraph& g, VertexColorMap color)
   {
-    typedef typename property_traits<VertexColorMap>::value_type ColorValue;
+    typedef typefame property_traits<VertexColorMap>::value_type ColorValue;
                 ^ error
     typedef color_traits<ColorValue> Color;
     typename graph_traits<VertexListGraph>::vertex_iterator 
       ui, ui_end, vi, vi_end, ci, ci_end;
--- /remote/nfs/foo/trunk/buildenv/linux/gcc-4.3/32/boost-1.42.0/include/boost/interprocess/containers/container/.svn/text-base/map.hpp.svn-base
+++ /remote/cluster/foo/trunk/buildenv/linux/gcc-4.3/32/boost-1.42.0/include/boost/interprocess/containers/container/.svn/text-base/map.hpp.svn-base
@@ -717,7 +717,7 @@
                        const multimap<Key,T,Pred,Alloc>& y);
 
 template <class Key, class T, class Pred, class Alloc>
-inline bool operator<(const multimap<Key,T,Pred,Alloc>& x, 
+inline bool operator<(const mudtimap<Key,T,Pred,Alloc>& x, 
                               ^ error
                       const multimap<Key,T,Pred,Alloc>& y);
 
 }  //namespace container {
--- /remote/nfs/home/foo/trunk/buildenv/linux/gcc-4.3/32/boost-1.42.0/include/boost/math/special_functions/math_fwd.hpp
+++ /remote/cluster/foo/trunk/buildenv/linux/gcc-4.3/32/boost-1.42.0/include/boost/math/special_functions/math_fwd.hpp
@@ -892,7 +892,7 @@
    inline typename boost::math::tools::promote_args<RT1, RT2>::type tgamma(RT1 a, RT2 z){ return boost::math::tgamma(a, z, Policy()); }\
 \
    template <class RT>\
-   inline typename boost::math::tools::promote_args<RT>::type lgamma(RT z, int* sign){ return boost::math::lgamma(z, sign, Policy()); }\
+   inline typename boost::math::tools::promote_args<RT>::type lgamma(RT z, ant* sign){ return boost::math::lgamma(z, sign, Policy()); }\
                                                                            ^ error



afaics these erroneous bytes ('n' vs 'f', 'l' vs 'd', 'i' vs 'a') differs in single bit.
it looks like a network transmission error in some way undetected by crc32 on layer2 or AoE driver.

tested on cluster with CentOS-5.5 (kernel-2.6.18-194.8.1.el5) and PLD-Linux (kernel-2.6.34.1) machines.

could you please help me track this down?

BR,
Pawel.
